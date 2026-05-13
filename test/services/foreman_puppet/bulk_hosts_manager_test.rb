require 'test_puppet_helper'

class BulkHostsManagerTest < ActiveSupport::TestCase
  let(:hosts) { FactoryBot.create_list(:host, 2, :with_puppet_enc) }
  let(:manager) { ::BulkHostsManager.new(hosts: hosts) }
  let(:proxy) { FactoryBot.create(:puppet_smart_proxy) }

  test 'changes puppet proxy for hosts' do
    manager.change_puppet_proxy(proxy, false)

    hosts.each do |host|
      assert_equal proxy.id, host.reload.puppet_proxy_id
    end
  end

  test 'changes puppet ca proxy for hosts' do
    manager.change_puppet_proxy(proxy, true)

    hosts.each do |host|
      assert_equal proxy.id, host.reload.puppet_ca_proxy_id
    end
  end

  test 'clears puppet proxy when proxy is nil' do
    hosts.each { |host| host.update!(puppet_proxy: proxy) }

    manager.change_puppet_proxy(nil, false)

    hosts.each do |host|
      assert_nil host.reload.puppet_proxy
    end
  end
end
