require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  class SmartProxyTest < ActiveSupport::TestCase
    let(:proxy) { FactoryBot.create(:puppet_smart_proxy) }

    test 'should return environment stats' do
      ProxyAPI::Puppet.any_instance.expects(:environments).returns(%w[env1 env2])
      ProxyAPI::Puppet.any_instance.expects(:class_count).with('env1').returns(1)
      ProxyAPI::Puppet.any_instance.expects(:class_count).with('env2').returns(2)
      assert_equal({ 'env1' => 1, 'env2' => 2 }, proxy.statuses[:puppet].environment_stats)
    end

    describe 'older v1 api' do
      before do
        ProxyAPI::V2::Features.any_instance.stubs(:features).raises(NotImplementedError.new('not supported'))
      end

      test 'can count connected hosts' do
        FactoryBot.create(:host, :with_puppet_enc, :with_environment, puppet_proxy: proxy)

        as_admin do
          assert_equal 1, proxy.hosts_count
        end
      end
    end
  end
end
