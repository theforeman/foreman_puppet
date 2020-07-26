module ForemanPuppetEnc
  class HostConfigGroup < ApplicationRecord
    self.table_name = 'host_config_groups'
    include Authorizable
    audited :associated_with => :host
    belongs_to :host, :polymorphic => true
    belongs_to :config_group

    validates :host_id, :uniqueness => { :scope => %i[config_group_id host_type] }

    def check_permissions_after_save
      true
    end
  end
end
