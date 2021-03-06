class MigrateHostTypeInHostConfigGroups < ActiveRecord::Migration[6.0]
  class FakeHostConfigGroup < ::ApplicationRecord
    self.table_name = 'host_config_groups'
  end

  def up
    host_config_group_ids = FakeHostConfigGroup.where(host_type: %w[Host::Base Host::Managed]).pluck(:host_id).uniq
    host_config_group_ids.each do |host_id|
      host_facet_id = ForemanPuppet::HostPuppetFacet.where(host_id: host_id).pick(:id)
      FakeHostConfigGroup.where(host_type: %w[Host::Base Host::Managed], host_id: host_id)
                         .update_all(host_type: 'ForemanPuppet::HostPuppetFacet', host_id: host_facet_id)
    end
    hostgroup_config_group_ids = FakeHostConfigGroup.where(host_type: 'Hostgroup').pluck(:host_id).uniq
    hostgroup_config_group_ids.each do |hostgroup_id|
      hostgroup_facet_id = ForemanPuppet::HostgroupPuppetFacet.where(hostgroup_id: hostgroup_id).pick(:id)
      FakeHostConfigGroup.where(host_type: 'Hostgroup', host_id: hostgroup_id)
                         .update_all(host_type: 'ForemanPuppet::HostgroupPuppetFacet', host_id: hostgroup_facet_id)
    end
  end

  def down
    host_config_group_ids = FakeHostConfigGroup.where(host_type: 'ForemanPuppet::HostPuppetFacet').pluck(:host_id).uniq
    host_facet_ids = ForemanPuppet::HostPuppetFacet.where(id: host_config_group_ids).pluck(:id, :host_id).to_h
    host_config_group_ids.each do |host_puppet_facet_id|
      FakeHostConfigGroup.where(host_type: 'ForemanPuppet::HostPuppetFacet', host_id: host_puppet_facet_id)
                         .update_all(host_type: 'Host::Managed', host_id: host_facet_ids[host_puppet_facet_id])
    end
    hostgroup_config_group_ids = FakeHostConfigGroup.where(host_type: 'ForemanPuppet::HostgroupPuppetFacet').pluck(:host_id).uniq
    hostgroup_facet_ids = ForemanPuppet::HostgroupPuppetFacet.where(id: hostgroup_config_group_ids).pluck(:id, :hostgroup_id).to_h
    hostgroup_config_group_ids.each do |hostgroup_facet_id|
      FakeHostConfigGroup.where(host_type: 'ForemanPuppet::HostgroupPuppetFacet', host_id: hostgroup_facet_id)
                         .update_all(host_type: 'Hostgroup', host_id: hostgroup_facet_ids[hostgroup_facet_id])
    end
  end
end
