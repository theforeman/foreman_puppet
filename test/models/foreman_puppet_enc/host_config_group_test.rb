require 'test_puppet_enc_helper'

module ForemanPuppetEnc
  class HostConfigGroupTest < ActiveSupport::TestCase
    should belong_to(:host)
    should belong_to(:config_group)
    should validate_uniqueness_of(:host_id).scoped_to(:config_group_id, :host_type)

    let(:environment) { FactoryBot.create(:environment) }
    let(:puppetclasses) { FactoryBot.create_list(:puppetclass, 4, environments: [environment]) }
    let(:config_group_with_classes) { FactoryBot.create(:config_group, puppetclasses: puppetclasses) }

    test 'relationship host.group_puppetclasses' do
      host = FactoryBot.create(:host, :with_puppet_enc, config_groups: [config_group_with_classes])
      assert_equal 4, host.puppet.group_puppetclasses.count
      assert_equal puppetclasses.map(&:id).sort, host.puppet.group_puppetclasses.pluck(:id).sort
    end

    test 'relationship host.config_groups ' do
      cgs = FactoryBot.create_list(:config_group, 2)
      host = FactoryBot.create(:host, :with_puppet_enc, config_groups: cgs)
      assert_equal 2, host.puppet.config_groups.count
      assert_equal cgs.map(&:name).sort, host.puppet.config_groups.pluck(:name).sort
    end

    test 'relationship hostgroup.group_puppetclasses' do
      hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, config_groups: [config_group_with_classes])
      assert_equal 4, hostgroup.puppet.group_puppetclasses.count
      assert_equal puppetclasses.map(&:id).sort, hostgroup.puppet.group_puppetclasses.pluck(:id).sort
    end

    test 'relationship hostgroup.config_groups' do
      cgs = FactoryBot.create_list(:config_group, 2)
      hostgroup = FactoryBot.create(:hostgroup, :with_puppet_enc, config_groups: cgs)
      assert_equal 2, hostgroup.puppet.config_groups.count
      assert_equal cgs.map(&:name).sort, hostgroup.puppet.config_groups.pluck(:name).sort
    end
  end
end
