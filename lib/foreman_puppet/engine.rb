module ForemanPuppet
  class Engine < ::Rails::Engine
    engine_name 'foreman_puppet'
    isolate_namespace ForemanPuppet

    config.paths['db/migrate'] << 'db/migrate_foreman' if Gem::Dependency.new('', ">= #{ForemanPuppet::FOREMAN_DROP_MIGRATIONS_VERSION}").match?('', SETTINGS[:version].notag)
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

      ::HostCounter.prepend ForemanPuppet::Extensions::HostCounter

      ::Api::V2::BaseController.include ForemanPuppet::Extensions::ApiBaseController
      ::Api::V2::HostsController.include ForemanPuppet::Extensions::ApiV2HostsController
      ::Api::V2::RegistrationController.prepend ForemanPuppet::Extensions::ApiV2RegistrationControllerExtensions
      ::Api::V2::HostgroupsController.include ForemanPuppet::Extensions::ApiHostgroupsController
      ::Api::V2::TemplateCombinationsController.include ForemanPuppet::Extensions::ApiTemplateCombinationsController
      ::Api::V2::HostsController.include ForemanPuppet::Extensions::ParametersHost
      ::Api::V2::HostgroupsController.include ForemanPuppet::Extensions::ParametersHostgroup
      ::ComputeResourcesVmsController.helper ForemanPuppet::HostsAndHostgroupsHelper
      ::OperatingsystemsController.prepend ForemanPuppet::Extensions::OperatingsystemsController
      ::HostsController.include ForemanPuppet::Extensions::HostsControllerExtensions
      ::HostsController.include ForemanPuppet::Extensions::ParametersHost
      ::HostgroupsController.include ForemanPuppet::Extensions::HostgroupsControllerExtensions
      ::HostgroupsController.include ForemanPuppet::Extensions::ParametersHostgroup

      ::SmartProxiesHelper::TABBED_FEATURES << 'Puppet'

      Foreman.input_types_registry.register(ForemanPuppet::InputType::PuppetParameterInput)
      ::ProxyStatus.status_registry.add(ForemanPuppet::ProxyStatus::Puppet)

      # Extend smart_proxies API functionality
      ::Api::V2::SmartProxiesController.include ForemanPuppet::Extensions::ApiSmartProxiesController

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
  end
end
