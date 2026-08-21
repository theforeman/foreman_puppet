module ForemanPuppet
  class HostConfigGroup < ApplicationRecord
    self.table_name = 'host_config_groups'
    include Authorizable
    audited associated_with: :host
    belongs_to :host, polymorphic: true
    belongs_to :config_group

    validates :host_id, uniqueness: { scope: %i[config_group_id host_type] }

    scope :assigned_to_taxonomy, lambda {
      host_facets = ForemanPuppet::HostPuppetFacet
                    .where(host_id: ::Host::Managed.reorder(nil).select(:id))
                    .select(:id)
      hostgroup_facets = ForemanPuppet::HostgroupPuppetFacet
                         .where(hostgroup_id: ::Hostgroup.unscoped.with_taxonomy_scope.reorder(nil).select(:id))
                         .select(:id)

      where(host_type: ForemanPuppet::HostPuppetFacet.polymorphic_name, host_id: host_facets)
        .or(where(host_type: ForemanPuppet::HostgroupPuppetFacet.polymorphic_name, host_id: hostgroup_facets))
    }

    def check_permissions_after_save
      true
    end
  end
end
