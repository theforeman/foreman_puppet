module ForemanPuppetEnc
  class ConfigGroupClass < ApplicationRecord
    self.table_name = 'config_group_classes'
    audited associated_with: :config_group

    include Authorizable

    belongs_to :puppetclass
    belongs_to :config_group

    validates :puppetclass, presence: true
    validates :config_group, presence: true,
                             uniqueness: { scope: :puppetclass_id }

    def check_permissions_after_save
      true
    end
  end
end
