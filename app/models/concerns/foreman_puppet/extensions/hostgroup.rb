module ForemanPuppet
  module Extensions
    module Hostgroup
      extend ActiveSupport::Concern

      include ForemanPuppet::Extensions::HostCommon

      included do
        class << self
          prepend PatchedClassMethods
        end

        has_one :environment, through: :puppet, class_name: 'ForemanPuppet::Environment'

        include_in_clone puppet: %i[host_config_groups config_groups hostgroup_classes]

        # will need through relation to work properly
        scoped_search relation: :environment, on: :name, complete_value: true, rename: :environment, only_explicit: true
        scoped_search relation: :puppetclasses, on: :name, complete_value: true, rename: :class, only_explicit: true, operators: ['= ', '~ ']
        scoped_search relation: :puppetclasses, on: :name,
          complete_value: true,
          rename: :puppetclass,
          only_explicit: true,
          operators: ['= ', '~ '],
          ext_method: :search_by_puppetclass
        scoped_search relation: :config_groups, on: :name,
          complete_value: true,
          rename: :config_group,
          only_explicit: true,
          operators: ['= ', '~ '],
          ext_method: :search_by_config_group
      end

      # Temporary, can be ordinary class_methods do, when removed from core
      module PatchedClassMethods
        def search_by_config_group(_key, operator, value)
          conditions = sanitize_sql_for_conditions(["config_groups.name #{operator} ?", value_to_sql(operator, value)])
          hostgroup_ids = ::Hostgroup.unscoped.with_taxonomy_scope.joins(puppet: :config_groups).where(conditions).map(&:subtree_ids).flatten.uniq

          opts = 'hostgroups.id < 0'
          opts = "hostgroups.id IN(#{hostgroup_ids.join(',')})" if hostgroup_ids.present?
          { conditions: opts }
        end

        def search_by_puppetclass(_key, operator, value)
          conditions = sanitize_sql_for_conditions(["puppetclasses.name #{operator} ?", value_to_sql(operator, value)])
          hostgroup_ids = ::Hostgroup.joins(puppet: :puppetclasses).where(conditions).map(&:subtree_ids)

          conds = []
          conds << "hostgroups.id IN (#{hostgroup_ids.join(',')})" if hostgroup_ids.present?

          { conditions: conds.join(' OR ').presence || 'hostgroups.id < 0' }
        end
      end
    end
  end
end
