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

    test 'can complete Puppet class values' do
      puppetclass = FactoryBot.create(:puppetclass)
      hostgroup.puppet.puppetclasses << puppetclass
      completions = ::Hostgroup.complete_for("puppetclass = #{puppetclass.name}")

      assert_includes completions, %(puppetclass =  "#{puppetclass.name}")
    end

    test 'can complete config group values' do
      config_group = hostgroup.puppet.config_groups.first
      completions = ::Hostgroup.complete_for("config_group = #{config_group.name}")

      assert_includes completions, %(config_group =  "#{config_group.name}")
    end

    test 'can complete Puppet class values inherited from a parent hostgroup' do
      parent = FactoryBot.create(:hostgroup, :with_puppet_enc, :with_puppetclass)
      FactoryBot.create(:hostgroup, parent: parent)
      puppetclass = parent.puppet.puppetclasses.first
      completions = ::Hostgroup.complete_for("puppetclass = #{puppetclass.name}")

      assert_includes completions, %(puppetclass =  "#{puppetclass.name}")
    end

    test 'searches Puppet class values assigned through a config group' do
      config_group = hostgroup.puppet.config_groups.first
      puppetclass = FactoryBot.create(:puppetclass)
      config_group.puppetclasses << puppetclass

      assert_includes ::Hostgroup.search_for("puppetclass = #{puppetclass.name}"), hostgroup
    end
  end
end
