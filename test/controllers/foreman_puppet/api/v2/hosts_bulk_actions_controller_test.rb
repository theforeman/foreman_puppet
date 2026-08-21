require 'test_puppet_helper'

module ForemanPuppet
  module Api
    module V2
      class HostsBulkActionsControllerTest < ActionController::TestCase
        tests ::ForemanPuppet::Api::V2::HostsBulkActionsController

        setup do
          @routes = ::Foreman::Application.routes
        end

        let(:host) { FactoryBot.create(:host, :with_puppet_enc) }
        let(:host2) do
          FactoryBot.create(:host, :with_puppet_enc,
            organization: host.organization,
            location: host.location)
        end
        let(:environment) { FactoryBot.create(:environment, organizations: [host.organization], locations: [host.location]) }
        let(:hostgroup_environment) { FactoryBot.create(:environment, organizations: [host.organization], locations: [host.location]) }
        let(:hostgroup) do
          FactoryBot.create(:hostgroup, :with_puppet_enc,
            environment: hostgroup_environment,
            organizations: [host.organization],
            locations: [host.location])
        end
        let(:proxy) { FactoryBot.create(:puppet_and_ca_smart_proxy, organizations: [host.organization], locations: [host.location]) }

        def put_change_environment(params:, session: nil)
          original_routes = @routes
          @routes = ForemanPuppet::Engine.routes
          put :change_environment, params: params, session: session
        ensure
          @routes = original_routes
        end

        test 'changes puppet environment for selected hosts' do
          put_change_environment(params: bulk_params.merge(environment_id: environment.id))

          assert_response :success
          assert_equal environment.id, host2.reload.puppet.environment_id
          assert_equal environment.id, host.reload.puppet.environment_id
        end

        test 'inherits puppet environment from hostgroups for selected hosts' do
          host.update!(hostgroup: hostgroup)
          host2.update!(hostgroup: hostgroup)

          put_change_environment(params: bulk_params.merge(environment_id: 'inherit'))

          assert_response :success
          assert_equal hostgroup_environment.id, host2.reload.puppet.environment_id
          assert_equal hostgroup_environment.id, host.reload.puppet.environment_id
        end

        test 'clears puppet environment for selected hosts' do
          host.puppet.update!(environment: environment)
          host2.puppet.update!(environment: environment)

          put_change_environment(
            params: bulk_params.merge(environment_id: nil),
            session: set_session_user
          )

          assert_response :success
          assert_nil host.reload.puppet.environment
          assert_nil host2.reload.puppet.environment
        end

        test 'returns error when puppet environment is missing' do
          missing_environment_id = 999_999

          put_change_environment(
            params: bulk_params.merge(environment_id: missing_environment_id),
            session: set_session_user
          )

          assert_response :unprocessable_entity
          response = JSON.parse(@response.body)
          assert_equal "A Puppet environment with id #{missing_environment_id} could not be found.",
            response.dig('error', 'message')
        end

        test 'returns error when changing puppet environment fails for some hosts' do
          ::BulkHostsManager.any_instance.expects(:change_puppet_environment)
                            .with(environment)
                            .returns([host2.id])

          put_change_environment(
            params: bulk_params.merge(environment_id: environment.id),
            session: set_session_user
          )

          assert_response :unprocessable_entity
          response = JSON.parse(@response.body)
          assert_equal 'Failed to change environment for 1 host',
            response.dig('error', 'message')
          assert_equal [host2.id], response.dig('error', 'failed_host_ids')
        end

        test 'returns error when puppet environment is outside host taxonomies' do
          invalid_environment = FactoryBot.create(:environment,
            organizations: [host.organization],
            locations: [FactoryBot.create(:location)])

          put_change_environment(
            params: bulk_params.merge(environment_id: invalid_environment.id),
            session: set_session_user
          )

          assert_response :unprocessable_entity
          response = JSON.parse(@response.body)
          assert_equal 'Selected Puppet environment is not assigned to the proper organization and/or location for all hosts.',
            response.dig('error', 'message')
          assert_equal [host.id, host2.id].sort, response.dig('error', 'failed_host_ids').sort
        end

        test 'changes puppet proxy for selected hosts' do
          put :change_puppet_proxy,
            params: bulk_params.merge(proxy_id: proxy.id, ca_proxy: false)

          assert_response :success
          assert_equal proxy.id, host2.reload.puppet_proxy_id
          assert_equal proxy.id, host.reload.puppet_proxy_id
        end

        test 'changes puppet ca proxy for selected hosts' do
          put :change_puppet_proxy,
            params: bulk_params.merge(proxy_id: proxy.id, ca_proxy: true)

          assert_response :success
          assert_equal proxy.id, host2.reload.puppet_ca_proxy_id
          assert_equal proxy.id, host.reload.puppet_ca_proxy_id
        end

        test 'removes puppet proxy for selected hosts' do
          host.update!(puppet_proxy: proxy)
          host2.update!(puppet_proxy: proxy)

          assert_equal proxy, host.reload.puppet_proxy

          put :remove_puppet_proxy,
            params: bulk_params.merge(ca_proxy: false),
            session: set_session_user

          assert_response :success
          assert_nil host.reload.puppet_proxy
          assert_nil host2.reload.puppet_proxy
        end

        test 'returns error when puppet proxy is missing' do
          missing_proxy_id = 999_999

          put :change_puppet_proxy,
            params: bulk_params.merge(proxy_id: missing_proxy_id, ca_proxy: false),
            session: set_session_user

          assert_response :unprocessable_entity
          response = JSON.parse(@response.body)
          assert_equal "A Smart Proxy with id #{missing_proxy_id} and the Puppet proxy feature could not be found.",
            response.dig('error', 'message')
        end

        test 'returns error when puppet ca proxy is missing' do
          missing_proxy_id = 999_999

          put :change_puppet_proxy,
            params: bulk_params.merge(proxy_id: missing_proxy_id, ca_proxy: true),
            session: set_session_user

          assert_response :unprocessable_entity
          response = JSON.parse(@response.body)
          assert_equal "A Smart Proxy with id #{missing_proxy_id} and the Puppet CA proxy feature could not be found.",
            response.dig('error', 'message')
        end

        test 'returns error when smart proxy is missing puppet feature' do
          invalid_proxy = FactoryBot.create(:smart_proxy, organizations: [host.organization], locations: [host.location])
          invalid_proxy.smart_proxy_feature_by_name('Puppet')&.destroy!

          put :change_puppet_proxy,
            params: bulk_params.merge(proxy_id: invalid_proxy.id, ca_proxy: false),
            session: set_session_user

          assert_response :unprocessable_entity
          response = JSON.parse(@response.body)
          assert_equal "A Smart Proxy with id #{invalid_proxy.id} and the Puppet proxy feature could not be found.",
            response.dig('error', 'message')
        end

        test 'returns error when smart proxy is missing puppet ca feature' do
          invalid_proxy = FactoryBot.create(:puppet_smart_proxy, organizations: [host.organization], locations: [host.location])

          put :change_puppet_proxy,
            params: bulk_params.merge(proxy_id: invalid_proxy.id, ca_proxy: true),
            session: set_session_user

          assert_response :unprocessable_entity
          response = JSON.parse(@response.body)
          assert_equal "A Smart Proxy with id #{invalid_proxy.id} and the Puppet CA proxy feature could not be found.",
            response.dig('error', 'message')
        end

        test 'returns error when changing puppet proxy fails for some hosts' do
          ::BulkHostsManager.any_instance.expects(:change_puppet_proxy)
                            .with(proxy, false)
                            .returns([host2.id])

          put :change_puppet_proxy,
            params: bulk_params.merge(proxy_id: proxy.id, ca_proxy: false),
            session: set_session_user

          assert_response :unprocessable_entity
          response = JSON.parse(@response.body)
          assert_equal 'Failed to change Puppet proxy for 1 host',
            response.dig('error', 'message')
          assert_equal [host2.id], response.dig('error', 'failed_host_ids')
        end

        test 'returns error when removing puppet proxy fails for some hosts' do
          host.update!(puppet_proxy: proxy)
          host2.update!(puppet_proxy: proxy)
          ::BulkHostsManager.any_instance.expects(:change_puppet_proxy)
                            .with(nil, false)
                            .returns([host.id])

          put :remove_puppet_proxy,
            params: bulk_params.merge(ca_proxy: false),
            session: set_session_user

          assert_response :unprocessable_entity
          response = JSON.parse(@response.body)
          assert_equal 'Failed to remove Puppet proxy for 1 host',
            response.dig('error', 'message')
          assert_equal [host.id], response.dig('error', 'failed_host_ids')
          assert_equal proxy.id, host.reload.puppet_proxy_id
        end

        test 'returns error when removing puppet ca proxy fails for some hosts' do
          host.update!(puppet_ca_proxy: proxy)
          host2.update!(puppet_ca_proxy: proxy)
          ::BulkHostsManager.any_instance.expects(:change_puppet_proxy)
                            .with(nil, true)
                            .returns([host.id])

          put :remove_puppet_proxy,
            params: bulk_params.merge(ca_proxy: true),
            session: set_session_user

          assert_response :unprocessable_entity
          response = JSON.parse(@response.body)
          assert_equal 'Failed to remove Puppet CA proxy for 1 host',
            response.dig('error', 'message')
          assert_equal [host.id], response.dig('error', 'failed_host_ids')
          assert_equal proxy.id, host.reload.puppet_ca_proxy_id
        end

        def bulk_params
          {
            organization_id: host.organization_id,
            included: { ids: [host.id, host2.id] },
            excluded: { ids: [] },
          }
        end
      end
    end
  end
end
