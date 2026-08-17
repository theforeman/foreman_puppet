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
        scoped_search relation: :search_puppetclasses, on: :name,
          complete_value: true,
          rename: :puppetclass,
          only_explicit: true,
          operators: ['= ', '~ '],
          ext_method: :search_by_puppetclass
        scoped_search relation: :search_config_groups, on: :name,
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
          hostgroup_ids = ::Hostgroup.joins(puppet: :config_groups).where(conditions).map(&:subtree_ids).flatten.uniq

          conds = 'hostgroups.id < 0'
          conds = "hostgroups.id IN(#{hostgroup_ids.join(',')})" if hostgroup_ids.present?

          { conditions: conds }
        end

        def search_by_puppetclass(_key, operator, value)
          conditions = sanitize_sql_for_conditions(["puppetclasses.name #{operator} ?", value_to_sql(operator, value)])
          hostgroup_ids = ::Hostgroup.joins(puppet: :puppetclasses).where(conditions).map(&:subtree_ids)
          config_group_ids = ForemanPuppet::ConfigGroup.joins(:puppetclasses).where(conditions).pluck(:id)
          if config_group_ids.any?
            hostgroup_cg_ids = ForemanPuppet::HostgroupPuppetFacet.joins(:host_config_groups)
                                                                  .where(host_config_groups: { config_group_id: config_group_ids })
                                                                  .pluck(:hostgroup_id)
            hostgroup_ids += ::Hostgroup.where(id: hostgroup_cg_ids).map(&:subtree_ids)
          end

          conds = []
          conds << "hostgroups.id IN (#{hostgroup_ids.uniq.join(',')})" if hostgroup_ids.present?

          { conditions: conds.join(' OR ').presence || 'hostgroups.id < 0' }
        end
      end
    end
  end
end
