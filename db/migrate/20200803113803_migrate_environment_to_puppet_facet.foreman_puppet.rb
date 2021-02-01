class MigrateEnvironmentToPuppetFacet < ActiveRecord::Migration[6.0]
  def up
    puppet_hostgroups = Hostgroup.where.not(environment_id: nil).pluck(:id, :environment_id)
    puppet_hostgroups.map! { |hg_id, env_id| { hostgroup_id: hg_id, environment_id: env_id } }
    ForemanPuppet::HostgroupPuppetFacet.insert_all(puppet_hostgroups) if puppet_hostgroups.any?

    puppet_hosts = Host::Managed.where.not(environment_id: nil).pluck(:id, :environment_id)
    puppet_hosts.map! { |host_id, env_id| { host_id: host_id, environment_id: env_id } }
    ForemanPuppet::HostPuppetFacet.insert_all(puppet_hosts) if puppet_hosts.any?
  end

  def down
    hostgroup_facet_ids = ForemanPuppet::HostgroupPuppetFacet.all.pluck(:hostgroup_id, :environment_id)
    hostgroup_facet_ids.each do |hostgroup_id, env_id|
      Hostgroup.where(id: hostgroup_id).update_all(environment_id: env_id)
    end
    host_facet_ids = ForemanPuppet::HostPuppetFacet.all.pluck(:host_id, :environment_id)
    host_facet_ids.each do |host_id, env_id|
      Host::Managed.where(id: host_id).update_all(environment_id: env_id)
    end
  end
end
