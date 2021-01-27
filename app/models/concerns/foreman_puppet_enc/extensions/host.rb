module ForemanPuppetEnc
  module Extensions
    module Host
      extend ActiveSupport::Concern

      included do
        include_in_clone puppet: %i[config_groups host_config_groups host_classes]

        env_assoc = reflect_on_association(:environment)
        env_assoc&.instance_variable_set(:@class_name, 'ForemanPuppetEnc::Environment')

        prepend PrependedMethods
      end

      # rubocop:disable Naming/MethodName
      def importNode(nodeinfo)
        facet = puppet || build_puppet
        facet.import_puppet_node(nodeinfo)
      end
      # rubocop:enable Naming/MethodName

      module PrependedMethods
        def provisioning_template(opts = {})
          opts[:environment_id] ||= puppet&.environment_id
          super(opts)
        end

        def available_template_kinds(provisioning = nil)
          kinds = template_kinds(provisioning)
          kinds.map do |kind|
            ProvisioningTemplate.find_template({ kind: kind.name,
                                                 operatingsystem_id: operatingsystem_id,
                                                 hostgroup_id: hostgroup_id,
                                                 environment_id: puppet&.environment_id })
          end.compact
        end
      end
    end
  end
end
