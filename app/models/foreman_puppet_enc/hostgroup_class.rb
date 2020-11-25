module ForemanPuppetEnc
  class HostgroupClass < ApplicationRecord
    self.table_name = 'hostgroup_classes'

    audited associated_with: :hostgroup
    include Authorizable

    belongs_to :puppetclass
    belongs_to :hostgroup_puppet_facet
    has_one :hostgroup, through: :hostgroup_puppet_facet

    validates :hostgroup_puppet_facet, presence: true
    validates :puppetclass_id, presence: true, uniqueness: { scope: :hostgroup_puppet_facet_id }

    def name
      "#{hostgroup} - #{puppetclass}"
    end

    def check_permissions_after_save
      true
    end
  end
end
