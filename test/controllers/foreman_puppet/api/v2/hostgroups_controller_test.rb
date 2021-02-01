require 'test_puppet_helper'

module ForemanPuppet
  module Api
    module V2
      class HostgroupsControllerTest < ActionController::TestCase
        tests ::Api::V2::HostgroupsController

        let(:hostgroup) { FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass, :with_config_group) }
        let(:non_puppet) { FactoryBot.create(:hostgroup, ptable: templates(:autopart)) }
        let(:inherited) { FactoryBot.create(:hostgroup, :with_puppet_enc, parent: non_puppet) }

        describe '#show' do
          test 'includes puppetclasses under puppet node' do
            get :show, params: { id: hostgroup.to_param }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(response.body)
            assert json_response['puppet']['puppetclasses'].is_a? Array
            response_pg_ids = json_response['puppet']['puppetclasses'].map { |pg| pg['id'] }
            assert_equal hostgroup.puppet.puppetclasses.pluck(:id), response_pg_ids
          end

          test 'include config_groups under puppet node' do
            get :show, params: { id: hostgroup.to_param }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(response.body)
            assert json_response['puppet']['config_groups'].is_a? Array
            response_cg_ids = json_response['puppet']['config_groups'].map { |cg| cg['id'] }
            assert_equal hostgroup.puppet.config_groups.pluck(:id), response_cg_ids
          end

          test 'include all_puppet clases for individual record under puppet node' do
            get :show, params: { id: hostgroup.id }
            assert_response :success
            show_response = ActiveSupport::JSON.decode(response.body)
            assert_not show_response.empty?
            assert_not_equal 0, show_response['puppet']['all_puppetclasses'].length
          end

          test 'includes puppetclasses for backward compatibility' do
            get :show, params: { id: hostgroup.to_param }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(response.body)
            assert json_response['puppetclasses'].is_a? Array
            response_pg_ids = json_response['puppetclasses'].map { |pg| pg['id'] }
            assert_equal hostgroup.puppet.puppetclasses.pluck(:id), response_pg_ids
          end

          test 'include config_groups for backward compatibility' do
            get :show, params: { id: hostgroup.to_param }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(response.body)
            assert json_response['config_groups'].is_a? Array
            response_cg_ids = json_response['config_groups'].map { |cg| cg['id'] }
            assert_equal hostgroup.puppet.config_groups.pluck(:id), response_cg_ids
          end

          test 'include all_puppet clases for individual record' do
            get :show, params: { id: hostgroup.id }
            assert_response :success
            show_response = ActiveSupport::JSON.decode(response.body)
            assert_not show_response.empty?
            assert_not_equal 0, show_response['all_puppetclasses'].length
          end

          test 'should show inherited parameters' do
            get :show, params: { id: inherited.to_param }
            assert_response :success
            show_response = ActiveSupport::JSON.decode(@response.body)
            assert_equal inherited.puppet.environment_id, show_response['environment_id']
            assert_nil show_response['inherited_environment_id']
            assert_nil show_response['ptable_id']
            assert_equal templates(:autopart).id, show_response['inherited_ptable_id']
          end
        end
      end
    end
  end
end
