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
            add_host_puppet_params_filter(filter)
          end
        end
      end

      module PatchedMethods
        def host_params(*attrs)
          params = super(*attrs)
          process_deprecated_puppet_params!(params)
          params
        end
      end

      class_methods do
        def add_host_puppet_params_filter(filter)
          filter.permit :environment_id, :environment_name, :environment,
            config_groups: [], config_group_ids: [], config_group_names: [],
            puppetclasses: [], puppetclass_ids: [], puppetclass_names: []

          # TODO: bring to core - this is what facets should do, but does not
          filter.permit(puppet_attributes: {})
        end
      end

      def process_deprecated_puppet_params!(params, top_level_hash = controller_name.singularize)
        process_deprecated_environment_params!(params, top_level_hash)
        process_deprecated_attributes!(params, top_level_hash)
      end

      def process_deprecated_environment_params!(params, top_level_hash = 'host')
        env_id = params.delete(:environment_id)
        env_name = params.delete(:environment_name)
        env = params.delete(:environment)

        return unless env_id || env_name || env
        ::Foreman::Deprecation.api_deprecation_warning("param #{top_level_hash}[environment_*] has been deprecated in favor of #{top_level_hash}[puppet_attributes][environment_*]")

        params[:puppet_attributes] ||= {}
        params[:puppet_attributes][:environment_id] ||= env_id if env_id
        params[:puppet_attributes][:environment_name] ||= env_name if env_name
        params[:puppet_attributes][:environment] ||= env if env
      end

      def process_deprecated_attributes!(params, top_level_hash = 'host')
        %w[puppetclass config_group].each do |relation|
          ids = params.delete("#{relation}_ids".to_sym)
          names = params.delete("#{relation}_names".to_sym)
          plains = params.delete(relation.pluralize.to_sym)

          next unless ids || names || plains
          ::Foreman::Deprecation.api_deprecation_warning("param #{top_level_hash}[#{relation}_*] has been deprecated in favor of #{top_level_hash}[puppet_attributes][#{relation}_*]")

          params[:puppet_attributes] ||= {}
          params[:puppet_attributes]["#{relation}_ids".to_sym] ||= ids if ids
          params[:puppet_attributes]["#{relation}_names".to_sym] ||= names if names
          params[:puppet_attributes][relation.pluralize.to_sym] ||= plains if plains
        end
      end
    end
  end
end
