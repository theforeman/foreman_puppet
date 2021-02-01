require 'test_puppet_helper'

module ForemanPuppet
  module Api
    module V2
      class HostsControllerTest < ActionController::TestCase
        tests ::Api::V2::HostsController

        let(:host) { FactoryBot.create(:host, :with_puppet_enc) }
        let(:environment) do
          FactoryBot.create(:environment, :with_puppetclass, organizations: [host.organization], locations: [host.location])
        end
        let(:puppet_proxy) { FactoryBot.create(:puppet_smart_proxy) }

        describe '#show' do
          test 'includes config_groups under puppet node' do
            get :show, params: { id: host.to_param }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(response.body)
            assert json_response['puppet']['config_groups'].is_a? Array
            response_cg_ids = json_response['puppet']['config_groups'].map { |cg| cg['id'] }
            assert_equal host.puppet.config_groups.pluck(:id), response_cg_ids
          end

          test 'includes puppetclasses under puppet node' do
            get :show, params: { id: host.to_param }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(response.body)
            assert json_response['puppet']['puppetclasses'].is_a? Array
            response_pg_ids = json_response['puppet']['puppetclasses'].map { |pg| pg['id'] }
            assert_equal host.puppet.puppetclasses.pluck(:id), response_pg_ids
          end

          test 'includes config_groups for backward compatibility' do
            get :show, params: { id: host.to_param }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(response.body)
            assert json_response['config_groups'].is_a? Array
            response_cg_ids = json_response['config_groups'].map { |cg| cg['id'] }
            assert_equal host.puppet.config_groups.pluck(:id), response_cg_ids
          end

          test 'includes puppetclasses for backward compatibility' do
            get :show, params: { id: host.to_param }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(response.body)
            assert json_response['puppetclasses'].is_a? Array
            response_pg_ids = json_response['puppetclasses'].map { |pg| pg['id'] }
            assert_equal host.puppet.puppetclasses.pluck(:id), response_pg_ids
          end

          test 'should show host puppet_proxy_name' do
            # cover issue #16525
            host.update(puppet_proxy: puppet_proxy)
            get :show, params: { id: host.to_param }
            assert_response :success
            json = ActiveSupport::JSON.decode(response.body)
            assert json.key?('puppet_proxy_name')
            assert_equal puppet_proxy.name, json['puppet_proxy_name']
          end
        end

        describe '#create' do
          test 'should create with puppet proxy' do
            host_params = FactoryBot.attributes_for(:host, managed: false).merge(environment_id: environment.id, puppet_proxy_id: puppet_proxy.to_param)
            post :create, params: { host: host_params }
            assert_response :created
            assert_equal puppet_proxy.name, JSON.parse(@response.body)['puppet_proxy']['name'], "Can't create host with puppet proxy #{puppet_proxy}"
          end
        end

        describe '#update' do
          test 'should update with puppet proxy' do
            put :update, params: { id: host.id, host: host.attributes.merge(puppet_proxy_id: puppet_proxy.id) }
            assert_response :success
            assert_equal puppet_proxy['name'], JSON.parse(@response.body)['puppet_proxy']['name'], "Can't update host with puppet proxy #{puppet_proxy}"
          end

          test 'should update with puppet class' do
            puppetclass = environment.puppetclasses.first
            put :update, params: { id: host.id, host: { environment_id: environment.id, puppetclass_ids: [puppetclass.id] } }
            assert_response :success
            response = JSON.parse(@response.body)
            assert_equal environment.id, response['environment_id'], "Can't update host with environment #{environment}"
            assert_equal puppetclass.id, response['puppetclasses'][0]['id'], "Can't update host with puppetclass #{puppetclass}"
          end
        end

        describe '#enc' do
          test 'should get ENC values of host' do
            get :enc, params: { id: host.to_param }
            assert_response :success
            response = ActiveSupport::JSON.decode(@response.body)
            puppet_class = response['data']['classes'].keys
            assert_equal host.puppetclasses.map(&:name), puppet_class
          end
        end
      end
    end
  end
end
