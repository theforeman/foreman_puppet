module ForemanPuppetEnc
  module Extensions
    module HostgroupsControllerExtensions
      extend ActiveSupport::Concern

      PUPPET_AJAX_REQUESTS = %w[environment_selected puppetclass_parameters].freeze

      included do
        alias_method :ajax_request_for_puppet_hostgroup_extensions, :ajax_request
        alias_method :taxonomy_scope_for_puppet_hostgroup_extensions, :taxonomy_scope

        before_action :ajax_request_for_puppet_hostgroup_extensions, only: PUPPET_AJAX_REQUESTS
        before_action :taxonomy_scope_for_puppet_hostgroup_extensions, only: PUPPET_AJAX_REQUESTS

        helper ForemanPuppetEnc::HostsAndHostgroupsHelper
        helper ForemanPuppetEnc::PuppetclassesHelper
        helper ForemanPuppetEnc::PuppetclassLookupKeysHelper

        # So we override the core actions, once Puppet is extracted, we can use module methods directly
        prepend Actions
      end

      module Actions
        def environment_selected
          env_id = params[:environment_id] || params[:hostgroup][:environment_id] || params.dig(:hostgroup, :puppet_attributes, :environment_id)
          return not_found if env_id.to_i.positive? && !(@environment = ForemanPuppetEnc::Environment.find(env_id))

          refresh_hostgroup
          puppet = @hostgroup.puppet || @hostgroup.build_puppet
          puppet.environment = @environment if @environment

          @hostgroup.puppetclasses = Puppetclass.where(id: params[:hostgroup][:puppetclass_ids])
          @hostgroup.config_groups = ConfigGroup.where(id: params[:hostgroup][:config_group_ids])
          render partial: 'hosts/form_puppet_enc_tab', locals: { obj: @hostgroup, resource_type: :hostgroup }
        end

        def puppetclass_parameters
          Taxonomy.as_taxonomy @organization, @location do
            render partial: 'foreman_puppet_enc/puppetclasses/classes_parameters',
                   locals: { obj: refresh_hostgroup }
          end
        end

        # params facets fix:
        def hostgroup_params(top_level_hash = controller_name.singularize)
          filter = self.class.hostgroup_params_filter
          filter.permit(puppet_attributes: {})
          filter.filter_params(params, parameter_filter_context, top_level_hash)
        end
      end
    end
  end
end
