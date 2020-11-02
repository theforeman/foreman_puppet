require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  class HostTest < ActiveSupport::TestCase
    test 'should read the Puppetserver URL from its proxy settings' do
      host = FactoryBot.build_stubbed(:host)
      assert_nil host.puppet_server_uri
      assert_empty host.puppetmaster

      proxy = FactoryBot.create(:puppet_smart_proxy, url: 'https://smartproxy.example.com:8443')
      host.puppet_proxy = proxy
      assert_equal 'https://smartproxy.example.com:8140', host.puppet_server_uri.to_s
      assert_equal 'smartproxy.example.com', host.puppetmaster

      features = {
        'puppet' => {
          settings: { 'puppet_url': 'https://puppet.example.com:8140' },
        },
      }
      SmartProxyFeature.import_features(proxy, features)
      assert_equal 'https://puppet.example.com:8140', host.puppet_server_uri.to_s
      assert_equal 'puppet.example.com', host.puppetmaster
    end

    test 'should find smart proxy ids' do
      host = FactoryBot.create(:host, :with_puppet_enc)
      puppet_id = host.puppet_proxy_id

      res = Host.smart_proxy_ids(Host.where(id: [host.id]))

      assert_includes res, puppet_id
    end

    test 'can search hosts by smart proxy' do
      host = FactoryBot.create(:host, :with_puppet_enc)
      proxy = FactoryBot.create(:puppet_and_ca_smart_proxy)
      results = Host.search_for("smart_proxy = #{proxy.name}")
      assert_equal 0, results.count
      host.update(puppet_proxy_id: proxy.id)
      results = Host.search_for("smart_proxy = #{proxy.name}")
      assert_equal 1, results.count
      assert_includes results, host
      # the results should not change even if the host has multiple connections to same proxy
      host.update(puppet_ca_proxy_id: proxy.id)
      results2 = Host.search_for("smart_proxy = #{proxy.name}")
      assert_equal results, results2
    end
  end
end
