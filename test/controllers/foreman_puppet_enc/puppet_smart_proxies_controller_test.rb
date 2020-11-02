require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  class PuppetSmartProxiesControllerTest < ActionController::TestCase
    setup do
      @routes = ForemanPuppetEnc::Engine.routes
      stub_smart_proxy_v2_features
    end

    test '#environments' do
      proxy = smart_proxies(:puppetmaster)
      fake_data = { 'env1' => 1, 'special_environment' => 4 }
      ForemanPuppetEnc::ProxyStatus::Puppet.any_instance.expects(:environment_stats).returns(fake_data)
      get :environments, params: { id: proxy.id }, session: set_session_user, xhr: true
      assert_response :success
      assert_template 'foreman_puppet_enc/puppet_smart_proxies/_environments'
      assert_includes @response.body, 'special_environment'
      assert_includes @response.body, '5' # the total is correct
    end

    test '#dashboard' do
      proxy = smart_proxies(:puppetmaster)
      get :dashboard, params: { id: proxy.id }, session: set_session_user, xhr: true
      assert_response :success
      assert_template 'foreman_puppet_enc/puppet_smart_proxies/_dashboard'
      assert_includes @response.body, 'Latest Events'
    end
  end
end
