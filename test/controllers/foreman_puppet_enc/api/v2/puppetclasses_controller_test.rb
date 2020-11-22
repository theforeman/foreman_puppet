require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  module Api
    module V2
      class PuppetclassesControllerTest < ActionController::TestCase
        let(:valid_attrs) { { name: 'PuppetClassValidName' } }

        let(:default_organization) { Organization.first }
        let(:default_location) { Location.first }
        let(:environment) do
          FactoryBot.create(:environment, locations: [default_location], organizations: [default_organization])
        end
        let(:puppetclass) { FactoryBot.create(:puppetclass, environments: [environment]) }
        let(:eager_load) { puppetclass }

        setup do
          @routes = ForemanPuppetEnc::Engine.routes
          eager_load
        end

        test 'should get index' do
          get :index
          assert_response :success
          assert_not json_response.empty?
          assert json_response['results'].is_a?(Hash)
        end

        test 'should get index with style=list' do
          get :index, params: { style: 'list' }
          assert_response :success
          assert_not json_response.empty?
          assert json_response['results'].is_a?(Array)
        end

        context 'with taxonomy given' do
          test 'index should return puppetclasses only in Organization' do
            get :index, params: { organization_id: default_organization.id }
            assert_include json_response['results'].map { |_, v| v[0]['id'] }, puppetclass.id
            assert_response :success
          end

          test 'index should return puppetclasses only in Organization' do
            get :index, params: { location_id: default_location.id }
            assert_include json_response['results'].map { |_, v| v[0]['id'] }, puppetclass.id
            assert_response :success
          end

          test 'index should return puppetclasses only in Organization' do
            get :index, params: { location_id: default_location.id, organization_id: default_organization.id }
            assert_include json_response['results'].map { |_, v| v[0]['id'] }, puppetclass.id
            assert_response :success
          end
        end

        test 'should create puppetclass' do
          assert_difference('Puppetclass.count') do
            post :create, params: { puppetclass: valid_attrs }
          end
          assert_response :created
          assert Puppetclass.exists?(name: valid_attrs[:name])
        end

        test 'should update puppetclass' do
          put :update, params: { id: puppetclass.to_param, puppetclass: valid_attrs }
          assert_response :success
          assert_equal valid_attrs[:name], puppetclass.reload.name
        end

        test 'should destroy puppetclasss' do
          assert_difference('Puppetclass.count', -1) do
            delete :destroy, params: { id: puppetclass.to_param }
          end
          assert_response :success
        end

        test 'should get puppetclasses for given host only' do
          host1 = FactoryBot.create(:host, :with_puppetclass)
          FactoryBot.create(:host, :with_puppetclass)
          get :index, params: { host_id: host1.to_param }
          assert_response :success
          assert_equal host1.puppetclasses.map(&:name).sort, json_response['results'].keys.sort
        end

        test 'should not get puppetclasses for nonexistent host' do
          get :index, params: { 'search' => 'host = imaginaryhost.nodomain.what' }
          assert_response :success
          assert_empty json_response['results']
        end

        test 'should get puppetclasses for hostgroup' do
          hostgroup = FactoryBot.create(:hostgroup, :with_puppetclass)
          get :index, params: { hostgroup_id: hostgroup.to_param }
          assert_response :success
          assert_not json_response['results'].empty?
          assert_equal hostgroup.puppetclasses.map(&:name).sort, json_response['results'].keys.sort
        end

        test 'should get puppetclasses for environment' do
          environment = FactoryBot.create(:environment, :with_puppetclass)
          get :index, params: { environment_id: environment.to_param }
          assert_response :success
          assert_not json_response['results'].empty?
          assert_equal environment.puppetclasses.map(&:name).sort, json_response['results'].keys.sort
        end

        test 'should show error if optional nested environment does not exist' do
          get :index, params: { environment_id: 'nonexistent' }
          assert_response 404
          assert_equal "Environment not found by id 'nonexistent'", json_response['message']
        end

        test 'should show puppetclass for host' do
          host = FactoryBot.create(:host, :with_puppet_enc, :with_puppetclass)
          get :show, params: { host_id: host.to_param, id: host.puppetclasses.first.id }
          assert_response :success
          assert_not_empty json_response
        end

        test 'should show puppetclass for hostgroup' do
          hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass)
          get :show, params: { hostgroup_id: hostgroup.to_param, id: hostgroup.puppetclasses.first.id }
          assert_response :success
          assert_not_empty json_response
        end

        test 'should show puppetclass for environment' do
          environment = FactoryBot.create(:environment, :with_puppetclass)
          get :show, params: { environment_id: environment, id: environment.puppetclasses.first.id }
          assert_response :success
          assert_not_empty json_response
        end

        test 'should not remove puppetclass params' do
          FactoryBot.create(:puppetclass_lookup_key, puppetclass: puppetclass)
          assert_equal 1, puppetclass.class_params.length
          put :update, params: { id: puppetclass.id, smart_class_parameter_ids: [] }
          puppetclass.reload
          assert_equal 1, puppetclass.class_params.length
        end
      end
    end
  end
end
