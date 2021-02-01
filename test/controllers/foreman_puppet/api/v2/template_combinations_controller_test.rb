require 'test_puppet_helper'

module ForemanPuppet
  module Api
    module V2
      class TemplateCombinationsControllerTest < ActionController::TestCase
        tests ::Api::V2::TemplateCombinationsController

        let(:environment) { FactoryBot.create(:environment) }
        let(:template_combination) { FactoryBot.create(:template_combination) }

        test 'should get index by environment' do
          FactoryBot.create(:template_combination, environment: template_combination.environment)
          get :index, params: { environment_id: template_combination.environment.to_param }
          json_response = ActiveSupport::JSON.decode(@response.body)
          assert_equal 2, json_response['results'].size, 'Should contain template_combinations in the response'
          assert_response :success
        end

        context 'with provisioning_template_id' do
          setup do
            Foreman::Deprecation.stubs(:api_deprecation_warning).never
          end

          test 'should get index' do
            FactoryBot.create(:template_combination, provisioning_template: template_combination.provisioning_template)
            get :index, params: { provisioning_template_id: template_combination.provisioning_template.id }
            json_response = ActiveSupport::JSON.decode(@response.body)
            assert_equal 2, json_response['results'].size, 'Should contain template_combinations in the response'
            assert_response :success
          end

          test 'should get template combination for template' do
            get :show, params: { provisioning_template_id: template_combination.provisioning_template.to_param, id: template_combination.id }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(@response.body)
            assert_not json_response.empty?
            assert_equal json_response['provisioning_template_id'], template_combination.provisioning_template_id
          end

          test 'should get template combination for environment' do
            get :show, params: { provisioning_template_id: template_combination.provisioning_template.to_param, id: template_combination.id }
            assert_response :success
            json_response = ActiveSupport::JSON.decode(@response.body)
            assert_not json_response.empty?
            assert_equal json_response['environment_id'], template_combination.environment_id
            assert_equal json_response['environment_name'], template_combination.environment.name
          end

          test 'should create valid' do
            as_admin do
              post :create, params: { template_combination: { environment_id: environment.id, hostgroup_id: hostgroups(:unusual).id },
                                      provisioning_template_id: template_combination.provisioning_template.id }
            end
            json_response = ActiveSupport::JSON.decode(@response.body)
            assert_equal(json_response['environment_id'], environment.id)
            assert_equal(json_response['hostgroup_id'], hostgroups(:unusual).id)
            assert_equal(json_response['provisioning_template_id'], template_combination.provisioning_template.id)
            assert_response :created
          end

          test 'should update template combination' do
            put :update, params: { template_combination: { environment_id: environment.id, hostgroup_id: hostgroups(:common).id },
                                   environment_id: template_combination.environment.id, id: template_combination.id }

            json_response = ActiveSupport::JSON.decode(@response.body)
            assert_equal(json_response['environment_id'], environment.id)
            assert_equal(json_response['hostgroup_id'], hostgroups(:common).id)
            assert_response :success
          end

          test 'should destroy' do
            delete :destroy, params: { id: template_combination.id }
            assert_response :ok
            assert_not TemplateCombination.exists?(template_combination.id)
          end
        end
      end
    end
  end
end
