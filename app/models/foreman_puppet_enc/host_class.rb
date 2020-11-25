module ForemanPuppetEnc
  class HostClass < ApplicationRecord
    self.table_name = 'host_classes'

    audited associated_with: :host
    include Authorizable

    validates_lengths_from_database
    belongs_to :puppetclass
    belongs_to :host_puppet_facet
    has_one :host, through: :host_puppet_facet

    validates :puppetclass_id, presence: true, uniqueness: { scope: :host_puppet_facet_id }

    def name
      "#{host_puppet_facet.host} - #{puppetclass}"
    end

    def check_permissions_after_save
      true
    end
  end
end
