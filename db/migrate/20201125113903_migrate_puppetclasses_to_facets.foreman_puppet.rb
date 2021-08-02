class MigratePuppetclassesToFacets < ActiveRecord::Migration[6.0]
  class FakeHostClass < ApplicationRecord
    self.table_name = 'host_classes'
  end

  class FakeHostgroupClass < ApplicationRecord
    self.table_name = 'hostgroup_classes'
  end

  class FakePuppetclass < ApplicationRecord
    self.table_name = 'puppetclasses'
  end

  def up
    add_reference :host_classes, :host_puppet_facet, foreign_key: true, index: true
    add_reference :hostgroup_classes, :hostgroup_puppet_facet, foreign_key: true, index: true

    host_ids = FakeHostClass.all.pluck(:host_id).uniq
    host_ids.each do |host_id|
      host_facet = ForemanPuppet::HostPuppetFacet.find_by(host_id: host_id)
      host_classes = ForemanPuppet::HostClass.where(host_id: host_id)
      if host_facet
        host_classes.update_all(host_puppet_facet_id: host_facet.id)
      else
        deleted_classes = FakePuppetclass.where(id: host_classes.pluck(:puppetclass_id)).pluck(:name)
        say "deleting classes #{deleted_classes.join(', ')} from Host (id=#{host_id}) because it has no environment"
        host_classes.delete_all
      end
    end
    hostgroup_ids = FakeHostgroupClass.all.pluck(:hostgroup_id).uniq
    hostgroup_ids.each do |hostgroup_id|
      hostgroup_facet = ForemanPuppet::HostgroupPuppetFacet.find_by(hostgroup_id: hostgroup_id)
      hostgroup_facet ||= ForemanPuppet::HostgroupPuppetFacet.create(hostgroup: Hostgroup.unscoped.find(hostgroup_id))
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

    host_facets_ids = ForemanPuppet::HostClass.joins(:host_puppet_facet).pluck(:host_puppet_facet_id, 'host_puppet_facets.host_id')
    host_facets_ids.each do |host_facet_id, host_id|
      ForemanPuppet::HostClass.where(host_puppet_facet_id: host_facet_id).update_all(host_id: host_id)
    end
    hostgroup_ids = ForemanPuppet::HostgroupClass.joins(:hostgroup_puppet_facet).pluck(:hostgroup_puppet_facet_id, 'hostgroup_puppet_facets.hostgroup_id')
    hostgroup_ids.each do |hostgroup_facet_id, hostgroup_id|
      ForemanPuppet::HostgroupClass.where(hostgroup_puppet_facet_id: hostgroup_facet_id).update_all(hostgroup_id: hostgroup_id)
    end

    remove_reference(:host_classes, :host_puppet_facet, index: true, foreign_key: true)
    remove_reference(:hostgroup_classes, :hostgroup_puppet_facet, index: true, foreign_key: true)
  end
end
