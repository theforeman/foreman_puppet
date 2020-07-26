module ForemanPuppetEnc
  module Host
    class PuppetFacet < ApplicationRecord
      audited :associated_with => :host
      self.table_name = 'host_puppet_facets'
      include ForemanPuppetEnc::HostCommon
      include Facets::Base
      include ::SelectiveClone

      include_in_clone :config_groups, :host_config_groups

      def clear_puppetinfo
        unless environment
          self.puppetclasses = []
          self.config_groups = []
        end
      end

      def parent_config_groups
        return [] unless hostgroup
        hostgroup.all_config_groups
      end
    end
  end
end
