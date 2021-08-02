class MigrateHostTypeInHostConfigGroups < ActiveRecord::Migration[6.0]
  class FakeHostConfigGroup < ::ApplicationRecord
    self.table_name = 'host_config_groups'

    scope :for_host, -> { where(host_type: %w[Host::Base Host::Managed]) }
    scope :for_hostgroup, -> { where(host_type: 'Hostgroup') }
    scope :for_host_facet, -> { where(host_type: 'ForemanPuppet::HostPuppetFacet') }
    scope :for_hostgroup_facet, -> { where(host_type: 'ForemanPuppet::HostgroupPuppetFacet') }
  end

  class FakeConfigGroup < ::ApplicationRecord
    self.table_name = 'config_groups'
  end

  def up
    host_config_group_ids = FakeHostConfigGroup.for_host.pluck(:host_id).uniq
    host_config_group_ids.each do |host_id|
      host_facet_id = ForemanPuppet::HostPuppetFacet.where(host_id: host_id).pick(:id)
      host_groups = FakeHostConfigGroup.for_host.where(host_id: host_id)
      if host_facet_id
        host_groups.update_all(host_type: 'ForemanPuppet::HostPuppetFacet', host_id: host_facet_id)
      else
        deleted_groups = FakeConfigGroup.where(id: host_groups.pluck(:config_group_id)).pluck(:name)
        say "deleting groups #{deleted_groups.join(', ')} from Host (id=#{host_id}) because it has no environment"
        host_groups.delete_all
      end
    end
    hostgroup_config_group_ids = FakeHostConfigGroup.for_hostgroup.pluck(:host_id).uniq
    hostgroup_config_group_ids.each do |hostgroup_id|
      hostgroup_facet_id = ForemanPuppet::HostgroupPuppetFacet.where(hostgroup_id: hostgroup_id).pick(:id)
      hostgroup_facet_id ||= ForemanPuppet::HostgroupPuppetFacet.create!(hostgroup: Hostgroup.unscoped.find(hostgroup_id)).id
      FakeHostConfigGroup.for_hostgroup
                         .where(host_id: hostgroup_id)
                         .update_all(host_type: 'ForemanPuppet::HostgroupPuppetFacet', host_id: hostgroup_facet_id)
    end
  end

  def down
    host_config_group_ids = FakeHostConfigGroup.for_host_facet.pluck(:host_id).uniq
    host_facet_ids = ForemanPuppet::HostPuppetFacet.where(id: host_config_group_ids).pluck(:id, :host_id).to_h
    host_config_group_ids.each do |host_puppet_facet_id|
      FakeHostConfigGroup.for_host_facet
                         .where(host_id: host_puppet_facet_id)
                         .update_all(host_type: 'Host::Managed', host_id: host_facet_ids[host_puppet_facet_id])
    end
    hostgroup_config_group_ids = FakeHostConfigGroup.for_hostgroup_facet.pluck(:host_id).uniq
    hostgroup_facet_ids = ForemanPuppet::HostgroupPuppetFacet.where(id: hostgroup_config_group_ids).pluck(:id, :hostgroup_id).to_h
    hostgroup_config_group_ids.each do |hostgroup_facet_id|
      FakeHostConfigGroup.for_hostgroup_facet
                         .where(host_id: hostgroup_facet_id)
                         .update_all(host_type: 'Hostgroup', host_id: hostgroup_facet_ids[hostgroup_facet_id])
    end
  end
end
