class MigrateHostTypeInHostConfigGroups < ActiveRecord::Migration[6.0]
  def up
    host_config_group_ids = HostConfigGroup.where(host_type: %w[Host::Base Host::Managed]).pluck(:host_id).uniq
    host_config_group_ids.each do |host_id|
      host_facet = ForemanPuppetEnc::Host::PuppetFacet.create!(host_id: host_id)
      HostConfigGroup.where(host_type: %w[Host::Base Host::Managed], host_id: host_id).update_all(host_type: 'ForemanPuppetEnc::HostFacet', host_id: host_facet.id)
    end
    hostgroup_config_group_ids = HostConfigGroup.where(host_type: 'Hostgroup').pluck(:host_id).uniq
    hostgroup_config_group_ids.each do |hostgroup_id|
      hostgroup_facet = ForemanPuppetEnc::Hostgroup::PuppetFacet.create!(hostgroup_id: hostgroup_id)
      HostConfigGroup.where(host_type: 'Hostgroup', host_id: hostgroup_id).update_all(host_type: 'ForemanPuppetEnc::HostgroupFacet', host_id: hostgroup_facet.id)
    end
  end
end
