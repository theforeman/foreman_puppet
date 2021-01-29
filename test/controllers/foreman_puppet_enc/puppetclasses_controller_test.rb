require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  class PuppetclassesControllerTest < ActionController::TestCase
    include PuppetclassLookupKeysHelper

    setup do
      @routes = ForemanPuppetEnc::Engine.routes
    end

    let(:org) { users(:one).organizations.first }
    let(:loc) { users(:one).locations.first }
    let(:environment) { FactoryBot.create(:environment, organizations: [org], locations: [loc]) }
    let(:puppetclass) { FactoryBot.create(:puppetclass, :with_parameters, environments: [environment]) }

    basic_pagination_rendered_test
    basic_pagination_per_page_test

    def test_index
      get :index, session: set_session_user
      assert_template 'index'
    end

    def test_edit
      get :edit, params: { id: puppetclass.to_param }, session: set_session_user
      assert_template 'edit'
    end

    def test_update_invalid
      put :update, params: { id: puppetclass.to_param, puppetclass: { name: nil } }, session: set_session_user
      assert_template 'edit'
    end

    def test_update_valid
      put :update, params: { id: puppetclass, puppetclass: { name: 'foo' } }, session: set_session_user
      assert_equal 'foo', puppetclass.reload.name
      assert_redirected_to puppetclasses_url
    end

    def test_destroy
      delete :destroy, params: { id: puppetclass.to_param }, session: set_session_user
      assert_redirected_to puppetclasses_url
      assert_not Puppetclass.exists?(puppetclass.id)
    end

    test 'user with viewer rights should fail to edit a puppetclass' do
      setup_user
      get :edit, params: { id: puppetclass.to_param }, session: set_session_user(:one)
      assert_equal(403, @response.status)
    end

    test 'user with viewer rights should succeed in viewing puppetclasses' do
      setup_user
      get :index, session: set_session_user
      assert_response :success
    end

    describe '#parameters' do
      setup { puppetclass.class_params.each { |plk| plk.update(override: true) } }

      test 'new db rows are not added to HostClass when POST to parameters' do
        host = FactoryBot.create(:host, :with_puppet_enc, :with_puppetclass)
        host_puppetclass_ids = host.host_classes.pluck(:puppetclass_id)
        params = {  id: puppetclass.id,
                    host_id: host.id,
                    host: { puppetclass_ids: (host_puppetclass_ids + [puppetclass.id]) } }
        assert_difference('HostClass.count', 0) do
          post :parameters, params: params, session: set_session_user
        end
      end

      test 'new db rows are not added to HostgroupClass when POST to parameters' do
        skip 'dont know how to achieve for now' unless ForemanPuppetEnc.extracted_from_core?
        hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass)
        hostgroup_puppetclass_ids = hostgroup.puppet.hostgroup_classes.pluck(:puppetclass_id)
        params = {  id: puppetclass.id,
                    host_id: hostgroup.id,
                    hostgroup: { puppetclass_ids: (hostgroup_puppetclass_ids + [puppetclass.id]) } }
        assert_difference('ForemanPuppetEnc::HostgroupClass.count', 0) do
          post :parameters, params: params, session: set_session_user
        end
      end

      # NOTES: for tests below testing ajax POST to method parameters
      # puppetclass(:two) has an overridable lookup key custom_class_param.
      # custom_class_param is a smart_class_param for production environment only AND is marked as :override => TRUE
      test 'puppetclass lookup keys are added to partial _class_parameters on EXISTING host form through ajax POST to parameters' do
        host = FactoryBot.create(:host, :with_puppet_enc, environment: environment)
        existing_host_attributes = host_attributes(host)
        post :parameters, params: { id: puppetclass.id, host_id: host.id,
                                    host: existing_host_attributes }, session: set_session_user
        assert_response :success
        lookup_keys_added = overridable_puppet_lookup_keys(puppetclass, host)
        assert_equal 1, lookup_keys_added.count
        assert_includes lookup_keys_added.map(&:key), puppetclass.class_params.first.key
      end

      test 'puppetclass smart class parameters are NOT added if environment does not match' do
        # below is the same test as above, except environment is changed from production to global_puppetmaster, so custom_class_param is NOT added
        host = FactoryBot.create(:host, :with_puppet_enc, environment: environment)
        existing_host_attributes = host_attributes(host)
        existing_host_attributes['puppet_attributes'] = { 'environment_id' => FactoryBot.create(:environment).id }
        post :parameters, params: { id: puppetclass.id, host_id: host.id,
                                    host: existing_host_attributes }, session: set_session_user
        assert_response :success
        as_admin do
          lookup_keys_added = overridable_puppet_lookup_keys(puppetclass, assigns(:obj))
          assert_equal 0, lookup_keys_added.count
          assert_not lookup_keys_added.map(&:key).include?(puppetclass.class_params.first.key)
        end
      end

      test 'puppetclass lookup keys are added to partial _class_parameters on EXISTING hostgroup form through ajax POST to parameters' do
        hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, environment: environment)
        existing_hostgroup_attributes = hostgroup_attributes(hostgroup)
        # host_id is posted instead of hostgroup_id per host_edit.js#load_puppet_class_parameters
        post :parameters, params: { id: puppetclass.id, host_id: hostgroup.id,
                                    hostgroup: existing_hostgroup_attributes }, session: set_session_user
        assert_response :success
        as_admin do
          lookup_keys_added = overridable_puppet_lookup_keys(puppetclass, hostgroup)
          assert_equal 1, lookup_keys_added.count
          assert_includes lookup_keys_added.map(&:key), puppetclass.class_params.first.key
        end
      end

      test 'puppetclass lookup keys are added to partial _class_parameters on NEW host form through ajax POST to parameters' do
        host = Host::Managed.new(name: 'new_host', puppet_attributes: { environment_id: environment.id })
        new_host_attributes = host_attributes(host)
        post :parameters, params: { id: puppetclass.id, host_id: 'undefined',
                                    host: new_host_attributes }, session: set_session_user
        assert_response :success
        as_admin do
          lookup_keys_added = overridable_puppet_lookup_keys(puppetclass, host)
          assert_equal 1, lookup_keys_added.count
          assert_includes lookup_keys_added.map(&:key), puppetclass.class_params.first.key
        end
      end

      test 'puppetclass lookup keys are added to partial _class_parameters on NEW hostgroup form through ajax POST to parameters' do
        hostgroup = Hostgroup.new(name: 'new_hostgroup', puppet_attributes: { environment_id: environment.id })
        new_hostgroup_attributes = hostgroup_attributes(hostgroup)
        # host_id is posted instead of hostgroup_id per host_edit.js#load_puppet_class_parameters
        post :parameters, params: { id: puppetclass.id, host_id: 'undefined',
                                    hostgroup: new_hostgroup_attributes }, session: set_session_user
        assert_response :success
        as_admin do
          lookup_keys_added = overridable_puppet_lookup_keys(puppetclass, hostgroup)
          assert_equal 1, lookup_keys_added.count
          assert_includes lookup_keys_added.map(&:key), puppetclass.class_params.first.key
        end
      end
    end

    test 'sorting by environment name on the index screen should work' do
      setup_user
      puppetclass
      get :index, params: { order: 'environment ASC' }, session: set_session_user
      assert_includes assigns(:puppetclasses), puppetclass
    end

    test 'text filtering on the index screen should work' do
      setup_user
      get :index, params: { search: puppetclass.name }, session: set_session_user
      assert_includes assigns(:puppetclasses), puppetclass
    end

    test 'predicate filtering on the index screen should work' do
      setup_user
      puppetclass
      get :index, params: { search: "environment = #{environment.name}" }, session: set_session_user
      assert_includes assigns(:puppetclasses), puppetclass
    end

    def test_override_enable
      puppetclass.class_params.first.update(override: false)
      assert_changes -> { puppetclass.class_params.first.reload.override }, from: false, to: true do
        post :override, params: { id: puppetclass.to_param, enable: 'true' }, session: set_session_user
      end
      assert_match(/overridden all parameters/, flash[:success])
      assert_redirected_to puppetclasses_url
    end

    def test_override_disable
      puppetclass.class_params.first.update(override: true)
      post :override, params: { id: puppetclass.to_param, enable: 'false' }, session: set_session_user
      assert_not puppetclass.class_params.reload.first.override
      assert_match(/reset all parameters/, flash[:success])
      assert_redirected_to puppetclasses_url
    end

    def test_override_none
      puppetclass = FactoryBot.create(:puppetclass)
      post :override, params: { id: puppetclass.to_param }, session: set_session_user
      assert_match(/No parameters to override/, flash[:error])
      assert_redirected_to puppetclasses_url
    end

    test 'user with edit_puppetclasses permission should succeed in overriding all parameters' do
      puppetclass.class_params.first.update(override: false)
      setup_user 'edit', 'puppetclasses'
      post :override, params: { id: puppetclass.to_param, enable: 'true' }, session: set_session_user(:one)
      assert_match(/overridden all parameters/, flash[:success])
      assert_redirected_to puppetclasses_url
    end

    test 'user without edit_puppetclasses permission should fail in overriding all parameters' do
      puppetclass.class_params.first.update(override: false)
      setup_user 'view', 'puppetclasses'
      post :override, params: { id: puppetclass.to_param, enable: 'true' }, session: set_session_user(:one)
      assert_match(/You are not authorized to perform this action/, response.body)
    end

    private

    def host_attributes(host)
      known_attrs = HostsController.host_params_filter.accessible_attributes(HostsController.parameter_filter_context)
      host.attributes.except('id', 'created_at', 'updated_at').slice(*known_attrs)
    end

    def hostgroup_attributes(hostgroup)
      known_attrs = HostgroupsController.hostgroup_params_filter.accessible_attributes(HostgroupsController.parameter_filter_context)
      hostgroup.attributes.except('id', 'created_at', 'updated_at', 'hosts_count', 'ancestry').slice(*known_attrs)
    end

    def setup_user(operation = nil, type = '', search = nil, user = :one)
      if operation.nil?
        @request.session[:user] = users(:one).id
        users(:one).roles       = [Role.default, Role.find_by(name: 'Viewer')]
      else
        super
      end
    end
  end
end
