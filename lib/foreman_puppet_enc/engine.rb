module ForemanPuppetEnc
  class Engine < ::Rails::Engine
    engine_name 'foreman_puppet_enc'
    isolate_namespace ForemanPuppetEnc

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

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
        security_block :foreman_puppet_enc do
          permission :view_foreman_puppet_enc, { :'foreman_puppet_enc/hosts' => [:new_action],
                                                 :'foreman_puppet_enc/react' => [:index] }
        end

        role 'ForemanPuppetEnc', [:view_foreman_puppet_enc]

        # add menu entry
        menu :top_menu, :template,
          url_hash: { controller: :'foreman_puppet_enc/hosts', action: :new_action },
          caption: 'ForemanPuppetEnc',
          parent: :hosts_menu,
          after: :hosts

        # add dashboard widget
        widget 'foreman_puppet_enc_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      EnvironmentClass.include ForemanPuppetEnc::EnvironmentClassDecorations
      Puppetclass.include ForemanPuppetEnc::PuppetclassDecorations
      HostsHelper.include ForemanPuppetEnc::HostsHelperExtensions
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
