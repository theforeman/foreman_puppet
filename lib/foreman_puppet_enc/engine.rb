module ForemanPuppetEnc
  class Engine < ::Rails::Engine
    engine_name 'foreman_puppet_enc'
    isolate_namespace ForemanPuppetEnc

    # Add any db migrations
    initializer 'foreman_puppet_enc.load_app_instance_data' do |app|
      ForemanPuppetEnc::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_puppet_enc.register_plugin', before: :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_puppet_enc do
        requires_foreman '>= 2.0.0'

        # Add Global JS file for extending foreman-core components and routes
        register_global_js_file 'fills'

        # Add permissions
        # security_block :foreman_puppet_enc do
        # end

        # add menu entry

        # add dashboard widget
      end
    end

    initializer 'foreman_puppet_enc.apipie' do
      p = Foreman::Plugin.find(:foreman_puppet_enc)
      p.apipie_documented_controllers(["#{ForemanPuppetEnc::Engine.root}/app/controllers/foreman_puppet_enc/api/v2/*.rb"])
      Apipie.configuration.checksum_path += ['/foreman_puppet_enc/api/']
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
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
