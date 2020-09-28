require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  module Api
    module V2
      class OverrideValuesControllerTest < ActionController::TestCase
        setup do
          @routes = ForemanPuppetEnc::Engine.routes
          lookup_key
        end

        let(:lookup_key) { FactoryBot.create(:puppetclass_lookup_key, path: %w[hostgroup comment os].join("\n")) }
        let(:lookup_value) { FactoryBot.create(:lookup_value, lookup_key: lookup_key, match: 'os=default') }

        test "should get override values for specific smart class parameter" do
          lookup_value
          FactoryBot.create(:lookup_value, lookup_key: lookup_key, match: 'comment=override')
          get :index, params: { smart_class_parameter_id: lookup_key.to_param }
          assert_response :success
          override_values = ActiveSupport::JSON.decode(@response.body)
          assert_not_empty override_values
          assert_equal 2, override_values["results"].length
        end

        test "should create override values for specific smart class parameter" do
          assert_difference('LookupValue.count') do
            post :create, params: { smart_class_parameter_id: lookup_key.to_param, override_value: { match: 'os=abc', value: 'liftoff' } }
          end
          assert_response :created
        end

        test "should show specific override values for specific smart class parameter" do
          get :show, params: { smart_class_parameter_id: lookup_key.to_param, id: lookup_value.id }
          results = ActiveSupport::JSON.decode(@response.body)
          assert_not_empty results
          assert_equal 'os=default', results['match']
          assert_response :success
        end

        test "should show specific override values using match" do
          get :show, params: { smart_class_parameter_id: lookup_key.to_param, id: lookup_value.match }
          results = ActiveSupport::JSON.decode(@response.body)
          assert_not_empty results
          assert_equal 'os=default', results['match']
          assert_response :success
        end

        test "should update specific override value" do
          put :update, params: { smart_class_parameter_id: lookup_key.to_param, id: lookup_value.id, override_value: { match: 'os=abc' } }
          assert_response :success
        end
        test "should update specific override value using match" do
          put :update, params: { smart_class_parameter_id: lookup_key.to_param, id: lookup_value.match, override_value: { match: 'os=abc' } }
          assert_response :success
        end

        test "should destroy specific override value" do
          lookup_value
          assert_difference('LookupValue.count', -1) do
            delete :destroy, params: { smart_class_parameter_id: lookup_key.to_param, id: lookup_value.id }
          end
          assert_response :success
        end
        test "should destroy specific override value using match" do
          lookup_value
          assert_difference('LookupValue.count', -1) do
            delete :destroy, params: { smart_class_parameter_id: lookup_key.to_param, id: lookup_value.match }
          end
          assert_response :success
        end

        [{ value: 'xyz=10' }, { match: 'os=string' }].each do |override_value|
          test "should not create override value without #{override_value.keys.first}" do
            assert_difference('LookupValue.count', 0) do
              post :create, params: { smart_class_parameter_id: lookup_key.id, override_value: override_value }
            end
            response = ActiveSupport::JSON.decode(@response.body)
            param_not_posted = (override_value.keys.first.to_s == 'match') ? 'Value' : 'Match' # The opposite of override_value is missing
            assert_match(/Validation failed: #{param_not_posted} can't be blank/, response['error']['message'])
            assert_response :error
          end
        end

        test_attributes pid: '2b205e9c-e50c-48cd-8ebb-3b6bea09be77'
        test "should create override value without when omit is true" do
          value = RFauxFactory.gen_alpha
          assert_difference('LookupValue.count', 1) do
            post :create, params: { smart_class_parameter_id: lookup_key.id, override_value: { match: 'os=string', value: value, omit: true } }
          end
          assert_response :success
          lookup_key.reload
          assert_equal('os=string', lookup_key.override_values.first.match)
          assert_equal lookup_key.override_values.first.value, value
          assert(lookup_key.override_values.first.omit)
        end

        test "should not create override value without when omit is false" do
          assert_difference('LookupValue.count', 0) do
            post :create, params: { smart_class_parameter_id: lookup_key.id, override_value: { match: 'os=string', omit: false } }
          end
          assert_response :error
        end

        test_attributes pid: 'bef0e457-16be-4ca6-bc56-fa32dff55a01'
        test "should not create invalid matcher for non existing attribute" do
          assert_difference('LookupValue.count', 0) do
            post :create, params: { smart_class_parameter_id: lookup_key.id, override_value: { match: 'hostgroup=nonexistingHG', value: RFauxFactory.gen_alpha } }
          end
          assert_includes JSON.parse(response.body)['error']['message'], 'Validation failed: Match hostgroup=nonexistingHG does not match an existing host group'
        end

        test_attributes pid: '49de2c9b-40f1-4837-8ebb-dfa40d8fcb89'
        test "should not create matcher with blank matcher value" do
          lookup_key.update(required: true)
          assert_difference('LookupValue.count', 0) do
            post :create, params: { smart_class_parameter_id: lookup_key.id, override_value: { match: 'os=string', value: '' } }
          end
          assert_includes JSON.parse(response.body)['error']['message'], "Validation failed: Value can't be blank"
        end

        test_attributes pid: '21668ef4-1a7a-41cb-98e3-dc4c664db351'
        test "should not create matcher with value that does not matches default type" do
          lookup_key = FactoryBot.create(:puppetclass_lookup_key, :boolean)
          assert_difference('LookupValue.count', 0) do
            post :create, params: { smart_class_parameter_id: lookup_key.id, override_value: { match: 'os=string', value: RFauxFactory.gen_alpha } }
          end
          assert_includes JSON.parse(response.body)['error']['message'], 'Validation failed: Value is invalid'
        end

        test_attributes pid: '19d319e6-9b12-485e-a680-c84d18742c40'
        test "should create matcher for attribute in parameter" do
          value = RFauxFactory.gen_alpha
          lookup_key = FactoryBot.create(:puppetclass_lookup_key, override_value_order: 'is_virtual')
          assert_difference('LookupValue.count') do
            post :create, params: { smart_class_parameter_id: lookup_key.id, override_value: { match: 'is_virtual=true', value: value } }
          end
          lookup_key.reload
          assert_equal('is_virtual=true', lookup_key.override_values.first.match)
          assert_equal lookup_key.override_values.first.value, value
        end

        context 'hidden' do
          let(:lookup_key) { FactoryBot.create(:puppetclass_lookup_key, hidden_value: true, default_value: 'hidden') }

          test "should show a override value as hidden unless show_hidden is true" do
            get :show, params: { smart_class_parameter_id: lookup_key.to_param, id: lookup_value.to_param }
            show_response = ActiveSupport::JSON.decode(@response.body)
            assert_equal lookup_value.hidden_value, show_response['value']
          end

          test "should show override value unhidden when show_hidden is true" do
            get :show, params: { smart_class_parameter_id: lookup_key.to_param, id: lookup_value.to_param, show_hidden: 'true' }
            show_response = ActiveSupport::JSON.decode(@response.body)
            assert_equal lookup_value.value, show_response['value']
          end

          test "should show a override value parameter as hidden when user in unauthorized for smart class variable" do
            setup_user "view", "puppetclasses"
            setup_user "view", "external_parameters"
            setup_user "edit", "external_variables"
            get :show, params: { smart_class_parameter_id: lookup_key.to_param, id: lookup_value.to_param, show_hidden: 'true' }
            show_response = ActiveSupport::JSON.decode(@response.body)
            assert_equal lookup_value.hidden_value, show_response['value']
          end
        end
      end
    end
  end
end
