require 'test_puppet_helper'

module ForemanPuppet
  class HostgroupTest < ActiveSupport::TestCase
    let(:hostgroup) { FactoryBot.create(:hostgroup, :with_puppet_enc, :with_config_group) }

    test 'search hostgroups by config group' do
      config_group = hostgroup.puppet.config_groups.first
      hostgroups = ::Hostgroup.search_for("config_group = #{config_group.name}")
      assert_equal 1, hostgroups.count
      assert_equal hostgroups.pluck(:id).sort, hostgroups.map(&:id).sort
    end

    test 'assign a puppet class to hostgroup without puppet facet' do
      puppet_class = FactoryBot.create(:puppetclass)
      hostgroup = FactoryBot.create(:hostgroup)
      # This would raise the following exception
      # NoMethodError: undefined method `<<' for #<ActiveRecord::Relation []>
      hostgroup.puppetclasses << puppet_class

      assert_not_nil hostgroup.puppet
      assert_includes hostgroup.puppet.puppetclasses, puppet_class
      assert_includes hostgroup.puppetclasses, puppet_class
    end
  end
end
