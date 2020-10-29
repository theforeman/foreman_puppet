module ForemanPuppetEnc
  class HostPuppetFacet < ApplicationRecord
    self.table_name = 'host_puppet_facets'
    audited associated_with: :host

    include Facets::Base
    include ForemanPuppetEnc::HostCommon
    include ::SelectiveClone

    include_in_clone :config_groups, :host_config_groups

    def clear_puppetinfo
      return if environment
      self.puppetclasses = []
      self.config_groups = []
    end

    def parent_config_groups
      return [] unless hostgroup
      hostgroup.all_config_groups
    end
  end
end
