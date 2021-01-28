require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  module Api
    module V2
      class HostClassesControllerTest < ActionController::TestCase
        setup do
          @routes = ForemanPuppetEnc::Engine.routes
        end

        let(:host) { FactoryBot.create(:host, :with_puppet_enc, :with_puppetclass) }

        test 'should get puppetclass ids for host' do
          get :index, params: { host_id: host.to_param }
          assert_response :success
          result_json = ActiveSupport::JSON.decode(response.body)
          assert_not result_json['results'].empty?
          assert_equal(1, result_json['results'].length)
        end

        test 'should add a puppetclass to a host' do
          puppetclass = FactoryBot.create(:puppetclass)
          assert_difference('host.puppet.host_classes.count') do
            post :create, params: { host_id: host.to_param, puppetclass_id: puppetclass.id }
          end
          assert_response :success
        end

        test 'should remove a puppetclass from a host' do
          assert_difference('host.puppet.host_classes.count', -1) do
            delete :destroy, params: { host_id: host.to_param, id: host.puppet.host_classes.first.puppetclass_id }
          end
          assert_response :success
        end

        test 'should not add a puppetclass that does not exist to a host' do
          post :create, params: { host_id: host.to_param, puppetclass_id: 'invalid_id' }
          assert_response :unprocessable_entity
        end

        test 'should not delete a puppetclass that does not exist from a host' do
          post :destroy, params: { host_id: host.to_param, id: 'invalid_id' }
          assert_response :unprocessable_entity
        end
      end
    end
  end
end
