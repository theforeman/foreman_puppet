module ForemanPuppetEnc
  class Engine < ::Rails::Engine
    engine_name 'foreman_puppet_enc'
    isolate_namespace ForemanPuppetEnc

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    if Gem::Dependency.new('', '>= 2.2').match?('', SETTINGS[:version])
      config.paths['db/migrate'] << 'db/migrate_foreman'
    end

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
          permission :view_config_groups, { :config_groups => %i[index auto_complete_search welcome],
                                            :"foreman_puppet_enc/api/v2/config_groups" => %i[index show],
                                            :'foreman_puppet_enc/react' => [:index] }
          permission :create_config_groups, { :config_groups => %i[new create],
                                              :"foreman_puppet_enc/api/v2/config_groups" => [:create] }
          permission :edit_config_groups, { :config_groups => %i[edit update],
                                            :"foreman_puppet_enc/api/v2/config_groups" => [:update] }
          permission :destroy_config_groups, { :config_groups => [:destroy],
                                               :"foreman_puppet_enc/api/v2/config_groups" => [:destroy] }
        end

        role 'ForemanPuppetEnc', [:view_foreman_puppet_enc]

        # add puppet ENC divider
        divider :top_menu, :parent => :configure_menu, :after => :configure, :caption => N_('Puppet ENC')

        # add menu entry
        add_menu_item :top_menu, :puppet_enc, {
          :caption => 'Config Groups',
          :engine => ForemanPuppetEnc::Engine, :parent => :configure_menu, :after => :ansible,
          :url_hash => { :controller => 'foreman_puppet_enc/config_groups', :action => :index }
        }
        # add dashboard widget
        widget 'foreman_puppet_enc_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1

        # register host and hostgroup facet
        # register_facet ForemanPuppetEnc::Host::PuppetFacet, :puppet_facet do
        #   configure_host
        #   configure_hostgroup(::ForemanPuppetEnc::Hostgroup::PuppetFacet)
        # end

        # extend host form with puppet ENC Tab
        extend_page('hosts/_form') do |context|
          context.add_pagelet :main_tabs,
            :name => N_('Puppet ENC'),
            :partial => 'foreman_puppet_enc/config_groups/config_groups_selection'
        end

        # extend hostgroup form with puppet ENC Tab
        extend_page('hostgroups/_form') do |context|
          context.add_pagelet :main_tabs,
            :name => N_('Puppet ENC'),
            :partial => 'foreman_puppet_enc/config_groups/config_groups_selection'
        end
      end
    end

    initializer 'foreman_puppet_enc.apipie' do
      p = Foreman::Plugin.find(:foreman_puppet_enc)
      p.apipie_documented_controllers(["#{ForemanPuppetEnc::Engine.root}/app/controllers/foreman_puppet_enc/api/v2/*.rb"])
      Apipie.configuration.checksum_path += ['/foreman_puppet_enc/api/']
    end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      EnvironmentClass.include ForemanPuppetEnc::EnvironmentClassDecorations
      Puppetclass.include ForemanPuppetEnc::PuppetclassDecorations
      # HostsHelper.include ForemanPuppetEnc::HostsHelperExtensions
      HostsController.include ForemanPuppetEnc::Concerns::Puppet::HostsControllerExtensions
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
