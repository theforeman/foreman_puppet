module ForemanPuppet
  class Engine < ::Rails::Engine
    config.before_configuration do
      unless ForemanPuppet.extracted_from_core?
        require 'graphql'

        module BaseObjectClassMethodPath
          def field(*args, **kwargs, &block)
            return if args.first == :environment && args.second.to_s == 'Types::Environment'
            return if args.first == :environments && args.second.node_type.to_s == 'Types::Environment'
            return if args.first == :puppetclass && args.second.to_s == 'Types::Puppetclass'
            return if args.first == :puppetclasses && args.second.node_type.to_s == 'Types::Puppetclass'

            super
          end
        end

        module RelayClassicMutationClassMethodPath
          # rubocop:disable Metrics/ParameterLists
          def argument(name, type, *rest, loads: nil, **kwargs, &block)
            # rubocop:enable Metrics/ParameterLists
            return if [::Types::Environment, ::Types::Puppetclass].include?(loads)

            super
          end
        end

        GraphQL::Types::Relay::BaseObject.extend(BaseObjectClassMethodPath)
        GraphQL::Schema::RelayClassicMutation.extend(RelayClassicMutationClassMethodPath)
      end
    end

    engine_name 'foreman_puppet'
    isolate_namespace ForemanPuppet

    config.paths['db/migrate'] << 'db/migrate_foreman' if Gem::Dependency.new('', ">= #{ForemanPuppet::FOREMAN_EXTRACTION_VERSION}").match?('', SETTINGS[:version])
    config.paths['config/routes.rb'].unshift('config/api_routes.rb')

    initializer 'foreman_puppet.register_plugin', before: :finisher_hook do |_app|
      require 'foreman_puppet/register'
      Apipie.configuration.checksum_path += ['/foreman_puppet/api/']
    end

    initializer 'foreman_puppet.migrate_by_default' do |app|
      unless Object.const_defined?(:APP_RAKEFILE)
        paths['db/migrate'].existent.each do |path|
          app.config.paths['db/migrate'] << path
        end
      end
    end

    initializer 'foreman_puppet.configure_assets', group: :assets do
      SETTINGS[:foreman_puppet] = { assets: { precompile: ['foreman_puppet.scss'] } }
    end

    initializer 'foreman_puppet.patch_parameters' do
      # Parameters should go ASAP as they need to be applied before they are included in core controller
      Foreman::Controller::Parameters::TemplateCombination.include ForemanPuppet::Extensions::ParametersTemplateCombination
    end

    # Include concerns in this config.to_prepare block
    # rubocop:disable Metrics/BlockLength
    config.to_prepare do
      # Facets extenstion is applied too early - before the Hostgroup is complete
      # We redefine thing, so we need to wait until complete definition of Hostgroup
      # thus separate patching instead of using facet patching
      ::Hostgroup.include ForemanPuppet::Extensions::Hostgroup

      # include_in_clone that is used in core Facets::ManagedHostExtensions doesn't support nested objects
      # we need to run our include_in_clone after, so the puppet without nested objects doesnt override the one including them
      ::Host::Managed.include ForemanPuppet::Extensions::Host

      ::LookupValue.include ForemanPuppet::PuppetLookupValueExtensions
      ::Operatingsystem.include ForemanPuppet::Extensions::Operatingsystem
      ::Nic::Managed.include ForemanPuppet::Extensions::NicManaged
      ::Report.include ForemanPuppet::Extensions::Report
      ::Location.include ForemanPuppet::Extensions::Taxonomy
      ::Organization.include ForemanPuppet::Extensions::Taxonomy
      ::User.include ForemanPuppet::Extensions::User
      ::TemplateCombination.include ForemanPuppet::Extensions::TemplateCombination
      ::ProvisioningTemplate.include ForemanPuppet::Extensions::ProvisioningTemplate

      ::Api::V2::BaseController.include ForemanPuppet::Extensions::ApiBaseController
      ::Api::V2::HostsController.include ForemanPuppet::Extensions::ApiV2HostsController
      ::Api::V2::HostgroupsController.include ForemanPuppet::Extensions::ApiHostgroupsController
      ::Api::V2::TemplateCombinationsController.include ForemanPuppet::Extensions::ApiTemplateCombinationsController
      ::Api::V2::HostsController.include ForemanPuppet::Extensions::ParametersHost
      ::Api::V2::HostgroupsController.include ForemanPuppet::Extensions::ParametersHostgroup
      ::OperatingsystemsController.prepend ForemanPuppet::Extensions::OperatingsystemsController
      ::HostsController.include ForemanPuppet::Extensions::HostsControllerExtensions
      ::HostsController.include ForemanPuppet::Extensions::ParametersHost
      ::HostgroupsController.include ForemanPuppet::Extensions::HostgroupsControllerExtensions
      ::HostgroupsController.include ForemanPuppet::Extensions::ParametersHostgroup

      ::SmartProxiesHelper::TABBED_FEATURES << 'Puppet'

      unless ForemanPuppet.extracted_from_core?
        ::HostInfo.local_entries.delete('HostInfoProviders::PuppetInfo'.safe_constantize)
        ::HostInfo.local_entries.delete('HostInfoProviders::ConfigGroupsInfo'.safe_constantize)
        ::ProxyStatus.status_registry.delete('ProxyStatus::Puppet'.safe_constantize)
        Foreman.input_types_registry.input_types.delete('puppet_parameter')
      end
      Foreman.input_types_registry.register(ForemanPuppet::InputType::PuppetParameterInput)
      ::ProxyStatus.status_registry.add(ForemanPuppet::ProxyStatus::Puppet)

      # GraphQL
      ::Types::Host.include(ForemanPuppet::Types::HostExtensions)
      ::Types::Hostgroup.include(ForemanPuppet::Types::HostgroupExtensions)
      ::Types::Location.include(ForemanPuppet::Types::LocationExtensions)
      ::Types::Organization.include(ForemanPuppet::Types::OrganizationExtensions)
      ::Types::InterfaceAttributesInput.include(ForemanPuppet::Types::InterfaceAttributesInputExtensions)

      ::Mutations::Hosts::Create.include(ForemanPuppet::Mutations::Hosts::CreateExtensions)
    rescue StandardError => e
      Rails.logger.warn "ForemanPuppet: skipping engine hook (#{e})\n#{e.backtrace.join("\n")}"
    end
    # rubocop:enable Metrics/BlockLength

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanPuppet::Engine.load_seed
      end
    end

    initializer 'foreman_puppet.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../..', __dir__), 'locale')
      locale_domain = 'foreman_puppet'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
