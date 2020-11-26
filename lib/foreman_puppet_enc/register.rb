Foreman::Plugin.register :foreman_puppet_enc do
  requires_foreman '>= 2.0.0'
  # Add Global JS file for extending foreman-core components and routes
  register_global_js_file 'fills'

  apipie_documented_controllers(["#{ForemanPuppetEnc::Engine.root}/app/controllers/foreman_puppet_enc/api/v2/*.rb"])

  unless ForemanPuppetEnc.extracted_from_core?
    # Remove core permissions
    cfgs = %i[view_config_groups create_config_groups edit_config_groups destroy_config_groups]
    plks = %i[view_external_parameters create_external_parameters edit_external_parameters
              destroy_external_parameters]
    pcls = %i[view_puppetclasses create_puppetclasses edit_puppetclasses destroy_puppetclasses import_puppetclasses]
    (cfgs | plks | pcls).each do |perm_name|
      p = Foreman::AccessControl.permission(perm_name)
      Foreman::AccessControl.remove_permission(p)
    end

    delete_menu_item(:top_menu, :puppetclasses)
    delete_menu_item(:top_menu, :config_groups)
    delete_menu_item(:top_menu, :puppetclass_lookup_keys)
    delete_menu_item(:top_menu, :environments)
  end

  # TODO: maybe this would not be necessary if we rething the form
  %i[create_hostgroups edit_hostgroups].each do |perm|
    p = Foreman::AccessControl.permission(perm)
    if ForemanPuppetEnc.extracted_from_core?
      p.actions << 'hostgroups/environment_selected'
      p.actions << 'hostgroups/puppetclass_parameters'
    end
    p.actions << 'foreman_puppet_enc/puppetclasses/parameters'
  end
  %i[create_hosts edit_hosts].each do |perm|
    p = Foreman::AccessControl.permission(perm)
    if ForemanPuppetEnc.extracted_from_core?
      p.actions << 'hosts/hostgroup_or_environment_selected'
      p.actions << 'hosts/puppetclass_parameters'
      if perm == 'edit_hosts'
        p.actions << 'hosts/select_multiple_environment'
        p.actions << 'hosts/update_multiple_environment'
        p.actions << 'hosts/select_multiple_puppet_proxy'
        p.actions << 'hosts/update_multiple_puppet_proxy'
      end
    end
    p.actions << 'foreman_puppet_enc/puppetclasses/parameters'
  end
  p = Foreman::AccessControl.permission(:view_smart_proxies)
  p.actions << 'foreman_puppet_enc/puppet_smart_proxies/dashboard'
  p.actions << 'foreman_puppet_enc/puppet_smart_proxies/environments'

  # Add permissions
  security_block :puppet_config_groups do
    permission :view_config_groups, { 'foreman_puppet_enc/config_groups': %i[index auto_complete_search welcome],
                                      'foreman_puppet_enc/api/v2/config_groups': %i[index show],
                                      'foreman_puppet_enc/react': [:index] },
      resource_type: 'ForemanPuppetEnc::ConfigGroup'
    permission :create_config_groups, { 'foreman_puppet_enc/config_groups': %i[new create],
                                        'foreman_puppet_enc/api/v2/config_groups': [:create] },
      resource_type: 'ForemanPuppetEnc::ConfigGroup'
    permission :edit_config_groups, { 'foreman_puppet_enc/config_groups': %i[edit update],
                                      'foreman_puppet_enc/api/v2/config_groups': [:update] },
      resource_type: 'ForemanPuppetEnc::ConfigGroup'
    permission :destroy_config_groups, { 'foreman_puppet_enc/config_groups': [:destroy],
                                         'foreman_puppet_enc/api/v2/config_groups': [:destroy] },
      resource_type: 'ForemanPuppetEnc::ConfigGroup'
  end

  security_block :puppet_lookup_keys do
    permission :view_external_parameters, { 'foreman_puppet_enc/puppetclass_lookup_keys': %i[index show auto_complete_search welcome],
                                            lookup_values: [:index],
                                            'foreman_puppet_enc/api/v2/smart_class_parameters': %i[index show],
                                            'foreman_puppet_enc/api/v2/override_values': %i[index show] },
      resource_type: 'ForemanPuppetEnc::PuppetclassLookupKey'
    permission :create_external_parameters, { 'foreman_puppet_enc/puppetclass_lookup_keys': %i[new create],
                                              lookup_values: [:create],
                                              'foreman_puppet_enc/api/v2/smart_class_parameters': [:create],
                                              'foreman_puppet_enc/api/v2/override_values': [:create] },
      resource_type: 'ForemanPuppetEnc::PuppetclassLookupKey'
    permission :edit_external_parameters, { 'foreman_puppet_enc/puppetclass_lookup_keys': %i[edit update],
                                            lookup_values: %i[create update destroy],
                                            'foreman_puppet_enc/api/v2/smart_class_parameters': [:update],
                                            'foreman_puppet_enc/api/v2/override_values': %i[create update destroy] },
      resource_type: 'ForemanPuppetEnc::PuppetclassLookupKey'
    permission :destroy_external_parameters, { 'foreman_puppet_enc/puppetclass_lookup_keys': [:destroy],
                                               lookup_values: [:destroy],
                                               'foreman_puppet_enc/api/v2/smart_class_parameters': [:destroy],
                                               'foreman_puppet_enc/api/v2/override_values': %i[create update destroy] },
      resource_type: 'ForemanPuppetEnc::PuppetclassLookupKey'
  end

  security_block :puppet_environments do
    permission :view_environments, { 'foreman_puppet_enc/environments': %i[index show auto_complete_search welcome],
                                     'foreman_puppet_enc/api/v2/environments': %i[index show] },
      resource_type: 'ForemanPuppetEnc::Environment'
    permission :create_environments, { 'foreman_puppet_enc/environments': %i[new create],
                                       'foreman_puppet_enc/api/v2/environments': %i[create] },
      resource_type: 'ForemanPuppetEnc::Environment'
    permission :edit_environments, { 'foreman_puppet_enc/environments': %i[edit update],
                                     'foreman_puppet_enc/api/v2/environments': %i[update] },
      resource_type: 'ForemanPuppetEnc::Environment'
    permission :destroy_environments, { 'foreman_puppet_enc/environments': %i[destroy],
                                        'foreman_puppet_enc/api/v2/environments': %i[destroy] },
      resource_type: 'ForemanPuppetEnc::Environment'
    permission :import_environments, { 'foreman_puppet_enc/environments': %i[import_environments obsolete_and_new],
                                       'foreman_puppet_enc/api/v2/environments': %i[import_puppetclasses] },
      resource_type: 'ForemanPuppetEnc::Environment'
  end

  security_block :puppetclasses do
    permission :view_puppetclasses,   { 'foreman_puppet_enc/puppetclasses' => %i[index show auto_complete_search],
                                        'foreman_puppet_enc/api/v2/puppetclasses' => %i[index show],
                                        'foreman_puppet_enc/api/v2/smart_class_parameters' => %i[index show] },
      resource_type: 'ForemanPuppetEnc::Puppetclass'
    permission :create_puppetclasses, { 'foreman_puppet_enc/puppetclasses' => %i[new create],
                                        'foreman_puppet_enc/api/v2/puppetclasses' => [:create] },
      resource_type: 'ForemanPuppetEnc::Puppetclass'
    permission :edit_puppetclasses,   { 'foreman_puppet_enc/puppetclasses' => %i[edit update override],
                                        'foreman_puppet_enc/api/v2/puppetclasses' => [:update],
                                        'foreman_puppet_enc/api/v2/smart_class_parameters' => %i[create update destroy] },
      resource_type: 'ForemanPuppetEnc::Puppetclass'
    permission :destroy_puppetclasses, { 'foreman_puppet_enc/puppetclasses' => [:destroy],
                                         'foreman_puppet_enc/api/v2/puppetclasses' => [:destroy] },
      resource_type: 'ForemanPuppetEnc::Puppetclass'
    permission :import_puppetclasses, { 'foreman_puppet_enc/puppetclasses' => %i[import_environments obsolete_and_new],
                                        'foreman_puppet_enc/api/v2/environments' => [:import_puppetclasses] },
      resource_type: 'ForemanPuppetEnc::Puppetclass'
  end

  add_all_permissions_to_default_roles
  Foreman::Plugin::RbacSupport::AUTO_EXTENDED_ROLES |= ['Site manager']
  add_permissions_to_default_roles('Site manager' => %w[view_puppetclasses import_puppetclasses view_environments import_environments])

  # add puppet ENC divider
  divider :top_menu, parent: :configure_menu, caption: N_('Puppet ENC')

  # add menu entries
  add_menu_item :top_menu, :environments, caption: N_('Environments'),
                                          engine: ForemanPuppetEnc::Engine,
                                          parent: :configure_menu
  add_menu_item :top_menu, :puppetclasses, caption: N_('Classes'),
                                           engine: ForemanPuppetEnc::Engine,
                                           parent: :configure_menu
  add_menu_item :top_menu, :config_groups, caption: N_('Config Groups'),
                                           engine: ForemanPuppetEnc::Engine,
                                           parent: :configure_menu
  add_menu_item :top_menu, :puppetclass_lookup_keys, caption: N_('Smart Class Parameters'),
                                                     engine: ForemanPuppetEnc::Engine,
                                                     parent: :configure_menu

  register_info_provider(ForemanPuppetEnc::HostInfoProviders::PuppetInfo)

  # register host and hostgroup facet
  register_facet ForemanPuppetEnc::HostPuppetFacet, :puppet do
    configure_host do
      # extend_model ForemanPuppetEnc::Extensions::Host
      api_view single: 'foreman_puppet_enc/api/v2/host_puppet_facets/main'
      template_compatibility_properties :environment_id, :environment
      set_dependent_action :destroy
    end
    configure_hostgroup(ForemanPuppetEnc::HostgroupPuppetFacet) do
      api_view single: 'foreman_puppet_enc/api/v2/hostgroup_puppet_facets/main'
      template_compatibility_properties :environment_id, :environment
      set_dependent_action :destroy
    end
  end

  unless ForemanPuppetEnc.extracted_from_core?
    Rails.application.config.after_initialize do
      list = Pagelets::Manager.instance.instance_variable_get(:@pagelets)['hosts/_form'][:main_tabs]
      core_pagelet = list.detect { |pagelet| pagelet.opts[:id] == :puppet_klasses }
      list.delete(core_pagelet)
    end
  end

  # extend host(group) form with puppet ENC Tab
  %i[host hostgroup].each do |resource_type|
    host_onlyif = ->(host, context) { context.send(:accessible_resource, host, :smart_proxy, :name, association: :puppet_proxy).present? }
    extend_page("#{resource_type}s/_form") do |context|
      context.add_pagelet :main_tabs,
        id: :puppet_enc_tab,
        name: N_('Puppet ENC'),
        partial: 'hosts/form_puppet_enc_tab',
        resource_type: resource_type,
        priority: 100,
        onlyif: (host_onlyif if resource_type == :host)

      if ForemanPuppetEnc.extracted_from_core?
        context.add_pagelet :main_tab_fields,
          partial: 'hosts/foreman_puppet_enc/form_main_tab_fields',
          resource_type: resource_type,
          priority: 100
      end
    end
  end
end
