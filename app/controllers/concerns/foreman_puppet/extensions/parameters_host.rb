module ForemanPuppet
  module Extensions
    module ParametersHost
      extend ActiveSupport::Concern

      included do
        class << self
          prepend PatchedClassMethods
        end

        prepend PatchedMethods
      end

      module PatchedClassMethods
        def host_params_filter
          super.tap do |filter|
            filter.permit :environment_id, :environment_name, :environment,
              config_groups: [], config_group_ids: [], config_group_names: [],
              puppetclasses: [], puppetclass_ids: [], puppetclass_names: []

            # TODO: bring to core - this is what facets should do, but does not
            filter.permit(puppet_attributes: {})
          end
        end
      end

      module PatchedMethods
        def host_params(*attrs)
          params = super(*attrs)

          process_deprecated_environment_params!(params)
          process_deprecated_attributes!(params)
          params
        end

        def process_deprecated_environment_params!(params)
          env_id = env_name = env = nil
          if ForemanPuppet.extracted_from_core?
            env_id = params.delete(:environment_id)
            env_name = params.delete(:environment_name)
            env = params.delete(:environment)
          else
            env_id = params[:environment_id]
            env_name = params[:environment_name]
            env = params[:environment]
          end

          return unless env_id || env_name || env
          ::Foreman::Deprecation.api_deprecation_warning('param host[environment_*] has been deprecated in favor of host[puppet_attributes][environment_*]')

          params[:puppet_attributes] ||= {}
          params[:puppet_attributes][:environment_id] ||= env_id if env_id
          params[:puppet_attributes][:environment_name] ||= env_name if env_name
          params[:puppet_attributes][:environment] ||= env if env
        end

        def process_deprecated_attributes!(params)
          %w[puppetclass config_groups].each do |relation|
            ids = params.delete("#{relation}_ids".to_sym)
            names = params.delete("#{relation}_names".to_sym)
            plains = params.delete(relation.pluralize.to_sym)

            next unless ids || names || plains
            ::Foreman::Deprecation.api_deprecation_warning("param host[#{relation}_*] has been deprecated in favor of host[puppet_attributes][#{relation}_*]")

            params[:puppet_attributes] ||= {}
            params[:puppet_attributes]["#{relation}_ids".to_sym] ||= ids if ids
            params[:puppet_attributes]["#{relation}_names".to_sym] ||= names if names
            params[:puppet_attributes][relation.pluralize.to_sym] ||= plains if plains
          end
        end
      end
    end
  end
end
