class MigrateHostTypeInHostConfigGroups < ActiveRecord::Migration[6.0]
  def up
    host_config_group_ids = HostConfigGroup.where(host_type: %w[Host::Base Host::Managed Hostgroup]).pluck(:config_group_id, :host_id)
    host_config_group_ids = host_config_group_ids.each_with_object(Hash.new([])) {|(cfg_id, host_id), memo| memo[host_id] += [cfg_id] }
    host_config_group_ids.each do |host_id, hcfg_ids|
      host_facet = ForemanPuppetEnc::Host::PuppetFacet.create(host_id: host_id)
      HostConfigGroup.where(host_type: %w[Host::Base Host::Managed], host_id: host_id).update_all(host_type: 'ForemanPuppetEnc::HostFacet', host_id: host_facet.id)
    end
    hostgroup_config_group_ids = HostConfigGroup.where(host_type: 'Hostgroup').pluck(:config_group_id, :host_id)
    hostgroup_config_group_ids = hostgroup_config_group_ids.each_with_object(Hash.new([])) {|(cfg_id, hostgroup_id), memo| memo[hostgroup_id] += [cfg_id] }
    hostgroup_config_group_ids.each do |hostgroup_id, hgcfg_ids|
      hostgroup_facet = ForemanPuppetEnc::Hostgroup::PuppetFacet.create(hostgroup_id: hostgroup_id)
      HostConfigGroup.where(host_type: 'Hostgroup', host_id: hostgroup_id).update_all(host_type: 'ForemanPuppetEnc::HostgroupFacet', host_id: hostgroup_facet.id)
    end
  end
end
