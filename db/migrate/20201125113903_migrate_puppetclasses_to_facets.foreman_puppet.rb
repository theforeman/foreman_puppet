class MigratePuppetclassesToFacets < ActiveRecord::Migration[6.0]
  def up
    add_reference :host_classes, :host_puppet_facet, foreign_key: true, index: true
    add_reference :hostgroup_classes, :hostgroup_puppet_facet, foreign_key: true, index: true

    host_ids = ForemanPuppet::HostClass.all.pluck(:host_id).uniq
    host_ids.each do |host_id|
      host_facet = ForemanPuppet::HostPuppetFacet.find_or_create_by(host_id: host_id)
      ForemanPuppet::HostClass.where(host_id: host_id).update_all(host_puppet_facet_id: host_facet.id)
    end
    hostgroup_ids = ForemanPuppet::HostgroupClass.all.pluck(:hostgroup_id).uniq
    hostgroup_ids.each do |hostgroup_id|
      hostgroup_facet = ForemanPuppet::HostgroupPuppetFacet.find_or_create_by(hostgroup_id: hostgroup_id)
      ForemanPuppet::HostgroupClass.where(hostgroup_id: hostgroup_id).update_all(hostgroup_puppet_facet_id: hostgroup_facet.id)
    end

    change_column_null(:host_classes, :host_id, true)
    change_column_null(:hostgroup_classes, :hostgroup_id, true)
    # remove_reference(:host_classes, :host, index: true, foreign_key: true)
    # remove_reference(:hostgroup_classes, :hostgroup, index: true, foreign_key: true)
  end

  def down
    # add_reference :host_classes, :host, foreign_key: true, index: true
    # add_reference :hostgroup_classes, :hostgroup, foreign_key: true, index: true

    host_facets_ids = ForemanPuppet::HostClass.includes(:host_puppet_facet).pluck(:host_puppet_facet_id, 'host_puppet_facets.host_id')
    host_facets_ids.each do |host_facet_id, host_id|
      ForemanPuppet::HostClass.where(host_puppet_facet_id: host_facet_id).update_all(host_id: host_id)
    end
    hostgroup_ids = ForemanPuppet::HostgroupClass.includes(:hostgroup_puppet_facet).pluck(:hostgroup_puppet_facet_id, 'hostgroup_puppet_facets.hostgroup_id')
    hostgroup_ids.each do |hostgroup_facet_id, hostgroup_id|
      ForemanPuppet::HostgroupClass.where(hostgroup_puppet_facet_id: hostgroup_facet_id).update_all(hostgroup_id: hostgroup_id)
    end

    remove_reference(:host_classes, :host_puppet_facet, index: true, foreign_key: true)
    remove_reference(:hostgroup_classes, :hostgroup_puppet_facet, index: true, foreign_key: true)
  end
end
