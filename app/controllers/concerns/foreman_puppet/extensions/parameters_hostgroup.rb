module ForemanPuppet
  module Extensions
    module ParametersHostgroup
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
            filter.permit :environment_id, :environment_name,
              config_group_ids: [], config_group_names: [],
              puppetclass_ids: [], puppetclass_names: []

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
          env_id = env_name = nil
          if ForemanPuppet.extracted_from_core?
            env_id = params.delete(:environment_id)
            env_name = params.delete(:environment_name)
          else
            env_id = params[:environment_id]
            env_name = params[:environment_name]
          end

          return unless env_id || env_name
          ::Foreman::Deprecation.api_deprecation_warning('param hostgroup[environment_*] has been deprecated in favor of hostgroup[puppet_attributes][environment_*]')

          params[:puppet_attributes] ||= {}
          params[:puppet_attributes][:environment_id] ||= env_id if env_id
          params[:puppet_attributes][:environment_name] ||= env_name if env_name
        end

        def process_deprecated_attributes!(params)
          %w[puppetclass config_groups].each do |relation|
            ids = params.delete("#{relation}_ids".to_sym)
            names = params.delete("#{relation}_names".to_sym)

            next unless ids || names
            ::Foreman::Deprecation.api_deprecation_warning("param hostgroup[#{relation}_*] has been deprecated in favor of hostgroup[puppet_attributes][#{relation}_*]")

            params[:puppet_attributes] ||= {}
            params[:puppet_attributes]["#{relation}_ids".to_sym] ||= ids if ids
            params[:puppet_attributes]["#{relation}_names".to_sym] ||= names if names
          end
        end
      end
    end
  end
end
