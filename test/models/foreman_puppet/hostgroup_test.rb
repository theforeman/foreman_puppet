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
  end
end
