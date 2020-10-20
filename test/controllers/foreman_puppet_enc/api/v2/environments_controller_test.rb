require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  module Api
    module V2
      class EnvironmentsControllerTest < ActionController::TestCase
        setup do
          @routes = ForemanPuppetEnc::Engine.routes
        end

        let(:environment_attrs) { { name: 'Development' } }
        let(:environment) { FactoryBot.create(:environment) }

        test 'should get index' do
          environment
          get :index
          assert_response :success
          assert_not_nil assigns(:environments)
          envs = ActiveSupport::JSON.decode(@response.body)
          assert_not envs.empty?
        end

        test 'should show environment by id or name' do
          get :show, params: { id: environment.id }
          assert_response :success
          assert_equal environment.name, JSON.parse(@response.body)['name']

          get :show, params: { id: environment.to_param }
          assert_response :success
          assert_equal environment.name, JSON.parse(@response.body)['name']

          get :show, params: { id: environment.name }
          assert_response :success
          assert_equal environment.name, JSON.parse(@response.body)['name']
        end

        test 'should create environment' do
          assert_difference('Environment.unscoped.count') do
            post :create, params: { environment: environment_attrs }
          end
          assert_response :created
        end

        test 'should create new environment with organization' do
          organization = Organization.first
          assert_difference 'Environment.unscoped.count' do
            post :create, params: { environment: { name: 'some_environment', organization_ids: [organization.id] } }, session: set_session_user
            response = JSON.parse(@response.body)
            assert_equal(1, response['organizations'].length)
            assert_equal response['organizations'][0]['id'], organization.id
          end
          assert_response :created, "Can't create environment with organization #{organization.name}"
        end

        test 'should create new environment with location' do
          location = Location.first
          assert_difference 'Environment.unscoped.count' do
            post :create, params: { environment: { name: 'some_environment', location_ids: [location.id] } }, session: set_session_user
            response = JSON.parse(@response.body)
            assert_equal(1, response['locations'].length)
            assert_equal response['locations'][0]['id'], location.id
          end
          assert_response :created, "Can't create environment with location #{location.name}"
        end

        test 'should not create with invalid name' do
          name = ''
          post :create, params: { environment: { name: name } }
          assert_response :unprocessable_entity, "Can create environment with invalid name #{name}"
        end

        test 'should update with valid name' do
          new_environment_name = RFauxFactory.gen_alphanumeric
          post :update, params: { id: environment.id, environment: { name: new_environment_name } }, session: set_session_user
          assert_equal JSON.parse(@response.body)['name'], new_environment_name, "Can't update environment with valid name #{name}"
        end

        test 'should not update with invalid name' do
          name = ''
          put :update, params: { id: environment.to_param, environment: { name: name } }
          assert_response :unprocessable_entity, "Can update environment with invalid name #{name}"
        end

        test 'should update environment' do
          put :update, params: { id: environment.to_param, environment: environment_attrs }
          assert_response :success
        end

        test 'should update environment with organization' do
          organization = Organization.first
          put :update, params: { id: environment.id, environment: { organization_ids: [organization.id] } }
          response = JSON.parse(@response.body)
          assert_equal(1, response['organizations'].length)
          assert_equal response['organizations'][0]['id'], organization.id
          assert_response :success, "Can't update environment with organization #{organization.name}"
        end

        test 'should update environment with location' do
          location = Location.first
          put :update, params: { id: environment.id, environment: { location_ids: [location.id] } }
          response = JSON.parse(@response.body)
          assert_equal(1, response['locations'].length)
          assert_equal response['locations'][0]['id'], location.id
          assert_response :success, "Can't update environment with location #{location.name}"
        end

        test 'should destroy environments' do
          environment
          assert_difference('Environment.unscoped.count', -1) do
            delete :destroy, params: { id: environment.to_param }
          end
          assert_response :success
        end
      end
    end
  end
end
