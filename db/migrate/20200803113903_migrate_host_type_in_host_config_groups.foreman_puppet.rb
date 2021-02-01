class MigrateHostTypeInHostConfigGroups < ActiveRecord::Migration[6.0]
  def up
    host_config_group_ids = HostConfigGroup.where(host_type: %w[Host::Base Host::Managed]).pluck(:host_id).uniq
    host_config_group_ids.each do |host_id|
      host_facet_id = ForemanPuppet::HostPuppetFacet.where(host_id: host_id).pick(:id)
      HostConfigGroup.where(host_type: %w[Host::Base Host::Managed], host_id: host_id).update_all(host_type: 'ForemanPuppet::HostPuppetFacet', host_id: host_facet_id)
    end
    hostgroup_config_group_ids = HostConfigGroup.where(host_type: 'Hostgroup').pluck(:host_id).uniq
    hostgroup_config_group_ids.each do |hostgroup_id|
      hostgroup_facet_id = ForemanPuppet::HostgroupPuppetFacet.where(hostgroup_id: hostgroup_id).pick(:id)
      HostConfigGroup.where(host_type: 'Hostgroup', host_id: hostgroup_id).update_all(host_type: 'ForemanPuppet::HostgroupPuppetFacet', host_id: hostgroup_facet_id)
    end
  end

  def down
    host_config_group_ids = HostConfigGroup.where(host_type: 'ForemanPuppet::HostPuppetFacet').pluck(:host_id).uniq
    host_facet_ids = Hash[ForemanPuppet::HostPuppetFacet.where(id: host_config_group_ids).pluck(:id, :host_id)]
    host_config_group_ids.each do |host_puppet_facet_id|
      HostConfigGroup.where(host_type: 'ForemanPuppet::HostPuppetFacet', host_id: host_puppet_facet_id)
                     .update_all(host_type: 'Host::Managed', host_id: host_facet_ids[host_puppet_facet_id])
    end
    hostgroup_config_group_ids = HostConfigGroup.where(host_type: 'ForemanPuppet::HostgroupPuppetFacet').pluck(:host_id).uniq
    hostgroup_facet_ids = Hash[ForemanPuppet::HostgroupPuppetFacet.where(id: hostgroup_config_group_ids).pluck(:id, :hostgroup_id)]
    hostgroup_config_group_ids.each do |hostgroup_facet_id|
      HostConfigGroup.where(host_type: 'ForemanPuppet::HostgroupPuppetFacet', host_id: hostgroup_facet_id)
                     .update_all(host_type: 'Hostgroup', host_id: hostgroup_facet_ids[hostgroup_facet_id])
    end
  end
end
