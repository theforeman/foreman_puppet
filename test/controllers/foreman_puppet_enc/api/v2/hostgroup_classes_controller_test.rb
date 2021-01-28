require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  module Api
    module V2
      class HostgroupClassesControllerTest < ActionController::TestCase
        setup do
          @routes = ForemanPuppetEnc::Engine.routes
        end

        let(:hostgroup) { FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass) }
        let(:puppetclass) { FactoryBot.create(:puppetclass) }

        test 'should get puppetclass ids for hostgroup' do
          get :index, params: { hostgroup_id: hostgroup.id }
          assert_response :success
          json_response = ActiveSupport::JSON.decode(response.body)
          assert_not json_response['results'].empty?
          assert_equal(1, json_response['results'].length)
        end

        test 'should add a puppetclass to a hostgroup' do
          hostgroup
          puppetclass
          assert_difference('hostgroup.puppet.hostgroup_classes.count') do
            post :create, params: { hostgroup_id: hostgroup.id, puppetclass_id: puppetclass.id }
          end
          assert_response :success
        end

        test 'should remove a puppetclass from a hostgroup' do
          hostgroup
          assert_difference('hostgroup.puppet.hostgroup_classes.count', -1) do
            delete :destroy, params: { hostgroup_id: hostgroup.id, id: hostgroup.puppet.puppetclass_ids.first }
          end
          assert_response :success
        end
      end
    end
  end
end
