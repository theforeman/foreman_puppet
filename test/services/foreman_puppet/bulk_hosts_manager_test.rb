require 'test_puppet_helper'

class BulkHostsManagerTest < ActiveSupport::TestCase
  let(:hosts) { FactoryBot.create_list(:host, 2, :with_puppet_enc) }
  let(:manager) { ::BulkHostsManager.new(hosts: hosts) }
  let(:proxy) { FactoryBot.create(:puppet_smart_proxy) }
  let(:environment) { FactoryBot.create(:environment, organizations: [hosts.first.organization], locations: [hosts.first.location]) }

  test 'changes puppet environment for hosts' do
    manager.change_puppet_environment(environment)

    hosts.each do |host|
      assert_equal environment.id, host.reload.puppet.environment_id
    end
  end

  test 'inherits puppet environment from hostgroup' do
    organization = FactoryBot.create(:organization)
    location = FactoryBot.create(:location)
    inherited_environment = FactoryBot.create(:environment, organizations: [organization], locations: [location])
    hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc,
      environment: inherited_environment,
      organizations: [organization],
      locations: [location])
    inherited_hosts = FactoryBot.create_list(:host, 2, :with_puppet_enc,
      environment: inherited_environment,
      hostgroup: hostgroup,
      organization: organization,
      location: location)

    ::BulkHostsManager.new(hosts: inherited_hosts).change_puppet_environment('inherit')

    inherited_hosts.each do |host|
      assert_equal inherited_environment.id, host.reload.puppet.environment_id
    end
  end

  test 'clears puppet environment when environment is nil' do
    hosts.each { |host| host.puppet.update!(environment: environment) }

    manager.change_puppet_environment(nil)

    hosts.each do |host|
      assert_nil host.reload.puppet.environment
    end
  end

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
