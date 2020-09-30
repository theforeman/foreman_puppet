module ForemanPuppetEnc
  class Engine < ::Rails::Engine
    engine_name 'foreman_puppet_enc'
    isolate_namespace ForemanPuppetEnc

    config.paths['db/migrate'] << 'db/migrate_foreman' if Gem::Dependency.new('', '>= 2.3').match?('', SETTINGS[:version])

    initializer 'foreman_puppet_enc.register_plugin', before: :finisher_hook do |_app|
      require 'foreman_puppet_enc/register'
    end

    initializer 'foreman_puppet_enc.apipie' do
      p = Foreman::Plugin.find(:foreman_puppet_enc)
      p.apipie_documented_controllers(["#{ForemanPuppetEnc::Engine.root}/app/controllers/foreman_puppet_enc/api/v2/*.rb"])
      Apipie.configuration.checksum_path += ['/foreman_puppet_enc/api/']
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      # Temporary
      EnvironmentClass.include ForemanPuppetEnc::EnvironmentClassDecorations
      Puppetclass.include ForemanPuppetEnc::PuppetclassDecorations
      # To stay
      LookupValue.include ForemanPuppetEnc::PuppetLookupValueExtensions
      HostsController.include ForemanPuppetEnc::Extensions::HostsControllerExtensions
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
