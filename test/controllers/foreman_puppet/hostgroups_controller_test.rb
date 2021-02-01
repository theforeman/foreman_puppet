require 'test_puppet_helper'

module ForemanPuppet
  class HostgroupsControllerTest < ActionController::TestCase
    tests ::HostgroupsController

    setup do
      @routes = ForemanPuppet::Engine.routes
    end

    describe '#environment_selected' do
      setup do
        @environment = FactoryBot.create(:environment)
        @puppetclass = FactoryBot.create(:puppetclass)
        @hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, environment: @environment)
        @params = {
          id: @hostgroup.id,
          hostgroup: {
            name: @hostgroup.name,
            environment_id: '',
            puppetclass_ids: [@puppetclass.id],
          },
        }
      end

      test 'should return the selected puppet classes on environment change' do
        assert_equal 0, @hostgroup.puppet.puppetclasses.length

        post :environment_selected, params: @params, session: set_session_user, xhr: true
        assert_equal(1, assigns(:hostgroup).puppet.puppetclasses.length)
        assert_include assigns(:hostgroup).puppet.puppetclasses, @puppetclass
      end

      context 'environment_id param is set' do
        test 'it will take the hostgroup params environment_id' do
          other_environment = FactoryBot.create(:environment)
          @params[:hostgroup][:environment_id] = other_environment.id

          post :environment_selected, params: @params, session: set_session_user, xhr: true
          assert_equal assigns(:environment), other_environment
        end
      end

      test 'should not escape lookup values on environment change' do
        hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, environment: @environment, puppetclasses: [@puppetclass])
        lookup_key = FactoryBot.create(:puppetclass_lookup_key, :array, default_value: %w[a b],
                                                                        override: true,
                                                                        puppetclass: @puppetclass,
                                                                        overrides: { "hostgroup=#{hostgroup.name}" => %w[c d] })
        lookup_value = lookup_key.lookup_values.first
        FactoryBot.create(:environment_class, puppetclass: @puppetclass, environment: @environment, puppetclass_lookup_key: lookup_key)

        # sending exactly what the host form would send which is lookup_value.value_before_type_cast
        lk = { 'lookup_values_attributes' => { lookup_key.id.to_s => { 'value' => lookup_value.value_before_type_cast,
                                                                       'id' => lookup_value.id,
                                                                       'lookup_key_id' => lookup_key.id,
                                                                       '_destroy' => false } } }

        params = {
          hostgroup_id: hostgroup.id,
          hostgroup: hostgroup.attributes.merge(lk),
        }

        # environment change calls puppetclass_parameters which caused the extra escaping
        post :puppetclass_parameters, params: params, session: set_session_user, xhr: true

        # if this was escaped during refresh_host the value in response.body after unescapeHTML would include "[\\\"c\\\",\\\"d\\\"]"
        assert_includes CGI.unescapeHTML(response.body), '["c","d"]'
      end
    end
  end
end
