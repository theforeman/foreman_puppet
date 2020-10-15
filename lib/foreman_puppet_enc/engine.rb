module ForemanPuppetEnc
  class Engine < ::Rails::Engine
    engine_name 'foreman_puppet_enc'
    isolate_namespace ForemanPuppetEnc

    config.paths['db/migrate'] << 'db/migrate_foreman' if ForemanPuppetEnc.extracted_from_core?
    config.paths['config/routes.rb'].unshift('config/api_routes.rb')

    initializer 'foreman_puppet_enc.register_plugin', before: :finisher_hook do |_app|
      require 'foreman_puppet_enc/register'
      Apipie.configuration.checksum_path += ['/foreman_puppet_enc/api/']
    end

    initializer 'foreman_puppet_enc.migrate_by_default' do |app|
      unless Object.const_defined?(:APP_RAKEFILE)
        paths['db/migrate'].existent.each do |path|
          app.config.paths['db/migrate'] << path
        end
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      # To stay
      LookupValue.include ForemanPuppetEnc::PuppetLookupValueExtensions
      Nic::Managed.include ForemanPuppetEnc::Extensions::NicManaged
      Report.include ForemanPuppetEnc::Extensions::Report
      Taxonomy.include ForemanPuppetEnc::Extensions::Taxonomy
      User.include ForemanPuppetEnc::Extensions::User
      HostsController.include ForemanPuppetEnc::Extensions::HostsControllerExtensions
      HostgroupsController.include ForemanPuppetEnc::Extensions::HostgroupsControllerExtensions

      SmartProxiesHelper::TABBED_FEATURES << 'Puppet'

      if !ForemanPuppetEnc.extracted_from_core? && (old_status = 'ProxyStatus::Puppet'.safe_constantize)
        ::ProxyStatus.status_registry.delete(old_status)
      end
      ::ProxyStatus.status_registry.add(ForemanPuppetEnc::ProxyStatus::Puppet)
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanPuppetEnc::Engine.load_seed
      end
    end

    initializer 'foreman_puppet_enc.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../..', __dir__), 'locale')
      locale_domain = 'foreman_puppet_enc'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
