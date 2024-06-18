module ForemanPuppet
  module Extensions
    module Host
      extend ActiveSupport::Concern

      include ForemanPuppet::Extensions::HostCommon

      included do
        prepend PrependedMethods

        has_one :environment, through: :puppet, class_name: 'ForemanPuppet::Environment'

        include_in_clone puppet: %i[config_groups host_config_groups host_classes]

        scoped_search relation: :environment, on: :name, complete_value: true, rename: :environment
        scoped_search relation: :puppetclasses, on: :name, complete_value: true, rename: :puppetclass, only_explicit: true, operators: ['= ', '~ '],
          ext_method: :search_by_puppetclass
        scoped_search relation: :config_groups, on: :name, complete_value: true, rename: :config_group, only_explicit: true, operators: ['= ', '~ '],
          ext_method: :search_by_config_group
      end

      class_methods do
        def search_by_puppetclass(_key, operator, value)
          conditions = sanitize_sql_for_conditions(["puppetclasses.name #{operator} ?", value_to_sql(operator, value)])
          config_group_ids = ForemanPuppet::ConfigGroup.joins(:puppetclasses).where(conditions).pluck(:id)
          host_ids         = ::Host.authorized(:view_hosts).joins(puppet: :puppetclasses).where(conditions).distinct.pluck(:id)
          host_ids        += ForemanPuppet::HostPuppetFacet.joins(:host_config_groups)
                                                           .where(host_config_groups: { config_group_id: config_group_ids })
                                                           .pluck(:host_id)
          hostgroup_ids = ::Hostgroup.unscoped.with_taxonomy_scope.joins(puppet: :puppetclasses).where(conditions).map(&:subtree_ids)
          if config_group_ids.any?
            hostgroup_cg_ids = ForemanPuppet::HostgroupPuppetFacet.joins(:host_config_groups)
                                                                  .where(host_config_groups: { config_group_id: config_group_ids })
                                                                  .pluck(:hostgroup_id)
            hostgroup_ids += ::Hostgroup.unscoped.with_taxonomy_scope.where(id: hostgroup_cg_ids).map(&:subtree_ids)
          end

          conds = []
          conds << "hosts.id IN(#{host_ids.join(',')})" if host_ids.present?
          conds << "hosts.hostgroup_id IN(#{hostgroup_ids.uniq.join(',')})" if hostgroup_ids.present?
          { conditions: conds.join(' OR ').presence || 'hosts.id < 0' }
        end

        def search_by_config_group(_key, operator, value)
          conditions = sanitize_sql_for_conditions(["config_groups.name #{operator} ?", value_to_sql(operator, value)])
          host_ids = ::Host::Managed.joins(puppet: :config_groups).where(conditions).pluck(:id).uniq
          hostgroup_ids = ::Hostgroup.unscoped.with_taxonomy_scope.joins(puppet: :config_groups).where(conditions).distinct.map(&:subtree_ids).flatten.uniq

          conds = []
          conds << "hosts.id IN(#{host_ids.join(',')})" if host_ids.present?
          conds << "hosts.hostgroup_id IN(#{hostgroup_ids.join(',')})" if hostgroup_ids.present?
          { conditions: conds.join(' OR ').presence || 'hosts.id < 0' }
        end
      end

      module PrependedMethods
        def provisioning_template(opts = {})
          opts[:environment_id] ||= puppet&.environment_id
          super(opts)
        end

        def available_template_kinds(provisioning = nil)
          kinds = template_kinds(provisioning)
          kinds.map do |kind|
            ::ProvisioningTemplate.find_template({ kind: kind.name,
                                                   operatingsystem_id: operatingsystem_id,
                                                   hostgroup_id: hostgroup_id,
                                                   environment_id: puppet&.environment_id })
          end.compact
        end

        # rubocop:disable Naming/MethodName
        def importNode(nodeinfo)
          facet = puppet || build_puppet
          facet.import_puppet_node(nodeinfo)
        end
        # rubocop:enable Naming/MethodName
      end
    end
  end
end
