require 'test_puppet_helper'

module ForemanPuppet
  class PuppetclassLookupKeysControllerTest < ActionController::TestCase
    setup do
      @routes = ForemanPuppet::Engine.routes
      @factory_options = [{ puppetclass: FactoryBot.create(:puppetclass), override: true, default_value: 'test' }]
    end

    let(:lookup_key) { FactoryBot.create(:puppetclass_lookup_key, override: true) }

    basic_pagination_rendered_test
    basic_pagination_per_page_test

    test 'should get index' do
      lookup_key # we dont want to render welcome
      get :index, session: set_session_user
      assert_response :success
      assert_not_nil assigns(:lookup_keys)
    end

    test 'should get edit' do
      get :edit, params: { id: lookup_key.to_param }, session: set_session_user
      assert_response :success
    end

    test 'should update lookup_keys' do
      put :update, params: { id: lookup_key.to_param, puppetclass_lookup_key: { description: 'test that' } }, session: set_session_user
      assert_equal 'test that', lookup_key.reload.description
      assert_redirected_to puppetclass_lookup_keys_path
    end

    test 'should destroy lookup_keys' do
      lookup_key
      assert_difference(-> { ForemanPuppet::PuppetclassLookupKey.count }, -1) do
        delete :destroy, params: { id: lookup_key.to_param }, session: set_session_user
      end
      assert_redirected_to puppetclass_lookup_keys_path
    end

    test 'user with viewer rights should fail to edit an external variable' do
      setup_user
      get :edit, params: { id: lookup_key.id }, session: set_session_user(:one)
      assert_equal(403, response.status)
    end

    test 'user with viewer rights should succeed in viewing external variables' do
      setup_user
      get :index, session: set_session_user(:one)
      assert_response :success
    end

    private

    def setup_user
      users(:one).roles = [Role.default, Role.find_by(name: 'Viewer')]
    end
  end
end
