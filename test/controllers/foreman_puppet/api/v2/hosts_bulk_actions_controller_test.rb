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
        let(:proxy) { FactoryBot.create(:puppet_and_ca_smart_proxy, organizations: [host.organization], locations: [host.location]) }

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
