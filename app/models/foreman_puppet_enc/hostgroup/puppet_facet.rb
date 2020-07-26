module ForemanPuppetEnc
  module Hostgroup
    class PuppetFacet < ApplicationRecord
      audited :associated_with => :hostgroup
      self.table_name = 'hostgroup_puppet_facets'
      include Facets::Base

      extend ActiveSupport::Concern
      include ForemanPuppetEnc::HostCommon
      include Facets::HostgroupFacet

      scoped_search :relation => :config_groups, :on => :name, :complete_value => true, :rename => :config_group, :only_explicit => true, :operators => ['= ', '~ '], :ext_method => :search_by_config_group

      def self.search_by_config_group(_key, operator, value)
        conditions = sanitize_sql_for_conditions(["config_groups.name #{operator} ?", value_to_sql(operator, value)])
        hostgroup_ids = ::Hostgroup.unscoped.with_taxonomy_scope.joins(:config_groups).where(conditions).map(&:subtree_ids).flatten.uniq

        opts = 'hostgroups.id < 0'
        opts = "hostgroups.id IN(#{hostgroup_ids.join(',')})" if hostgroup_ids.present?
        { :conditions => opts }
      end

      def all_config_groups
        (config_groups + parent_config_groups).uniq
      end

      def parent_config_groups
        return [] unless parent
        groups = []
        ancestors.each do |hostgroup|
          groups += hostgroup.config_groups
        end
        groups.uniq
      end
    end
  end
end
