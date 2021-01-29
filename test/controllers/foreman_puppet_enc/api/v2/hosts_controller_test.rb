require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  module Api
    module V2
      class HostsControllerTest < ActionController::TestCase
        tests ::Api::V2::HostsController

        let(:host) { FactoryBot.create(:host, :with_puppet_enc) }

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
        end

        describe '#edit' do
          test 'should update with puppet proxy' do
            puppet_proxy = FactoryBot.create(:puppet_smart_proxy)
            put :update, params: { id: host.id, host: host.attributes.merge(puppet_proxy_id: puppet_proxy.id) }
            assert_response :success
            assert_equal puppet_proxy['name'], JSON.parse(@response.body)['puppet_proxy']['name'], "Can't update host with puppet proxy #{puppet_proxy}"
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
