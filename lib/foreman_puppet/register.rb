Foreman::Plugin.register :foreman_puppet do
  requires_foreman '>= 2.0.0'
  # Add Global JS file for extending foreman-core components and routes
  register_global_js_file 'fills'

  apipie_documented_controllers(["#{ForemanPuppet::Engine.root}/app/controllers/foreman_puppet/api/v2/*.rb"])

  unless ForemanPuppet.extracted_from_core?
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
    if ForemanPuppet.extracted_from_core?
      p.actions << 'hostgroups/environment_selected'
      p.actions << 'hostgroups/puppetclass_parameters'
    end
    p.actions << 'foreman_puppet/puppetclasses/parameters'
  end
  p = Foreman::AccessControl.permission(:edit_hostgroups)
  %w[index create destroy].each do |action|
    p.actions << "foreman_puppet/api/v2/hostgroup_classes/#{action}"
  end
  %i[create_hosts edit_hosts].each do |perm|
    p = Foreman::AccessControl.permission(perm)
    if ForemanPuppet.extracted_from_core?
      p.actions << 'hosts/hostgroup_or_environment_selected'
      p.actions << 'hosts/puppetclass_parameters'
      if perm == :edit_hosts
        p.actions << 'hosts/select_multiple_environment'
        p.actions << 'hosts/update_multiple_environment'
        p.actions << 'hosts/select_multiple_puppet_proxy'
        p.actions << 'hosts/update_multiple_puppet_proxy'
      end
    end
    p.actions << 'foreman_puppet/puppetclasses/parameters'
  end

  p = Foreman::AccessControl.permission(:view_hosts)
  p.actions << 'hosts/externalNodes'

  p = Foreman::AccessControl.permission(:view_smart_proxies)
  p.actions << 'foreman_puppet/puppet_smart_proxies/dashboard'
  p.actions << 'foreman_puppet/puppet_smart_proxies/environments'

  # Add permissions
  security_block :puppet_config_groups do
    permission :view_config_groups, { 'foreman_puppet/config_groups': %i[index auto_complete_search welcome],
                                      'foreman_puppet/api/v2/config_groups': %i[index show],
                                      'foreman_puppet/react': [:index] },
      resource_type: 'ForemanPuppet::ConfigGroup'
    permission :create_config_groups, { 'foreman_puppet/config_groups': %i[new create],
                                        'foreman_puppet/api/v2/config_groups': [:create] },
      resource_type: 'ForemanPuppet::ConfigGroup'
    permission :edit_config_groups, { 'foreman_puppet/config_groups': %i[edit update],
                                      'foreman_puppet/api/v2/config_groups': [:update] },
      resource_type: 'ForemanPuppet::ConfigGroup'
    permission :destroy_config_groups, { 'foreman_puppet/config_groups': [:destroy],
                                         'foreman_puppet/api/v2/config_groups': [:destroy] },
      resource_type: 'ForemanPuppet::ConfigGroup'
  end

  security_block :puppet_lookup_keys do
    permission :view_external_parameters, { 'foreman_puppet/puppetclass_lookup_keys': %i[index show auto_complete_search welcome],
                                            lookup_values: [:index],
                                            'foreman_puppet/api/v2/smart_class_parameters': %i[index show],
                                            'foreman_puppet/api/v2/override_values': %i[index show] },
      resource_type: 'ForemanPuppet::PuppetclassLookupKey'
    permission :create_external_parameters, { 'foreman_puppet/puppetclass_lookup_keys': %i[new create],
                                              lookup_values: [:create],
                                              'foreman_puppet/api/v2/smart_class_parameters': [:create],
                                              'foreman_puppet/api/v2/override_values': [:create] },
      resource_type: 'ForemanPuppet::PuppetclassLookupKey'
    permission :edit_external_parameters, { 'foreman_puppet/puppetclass_lookup_keys': %i[edit update],
                                            lookup_values: %i[create update destroy],
                                            'foreman_puppet/api/v2/smart_class_parameters': [:update],
                                            'foreman_puppet/api/v2/override_values': %i[create update destroy] },
      resource_type: 'ForemanPuppet::PuppetclassLookupKey'
    permission :destroy_external_parameters, { 'foreman_puppet/puppetclass_lookup_keys': [:destroy],
                                               lookup_values: [:destroy],
                                               'foreman_puppet/api/v2/smart_class_parameters': [:destroy],
                                               'foreman_puppet/api/v2/override_values': %i[create update destroy] },
      resource_type: 'ForemanPuppet::PuppetclassLookupKey'
  end

  security_block :puppet_environments do
    permission :view_environments, { 'foreman_puppet/environments': %i[index show auto_complete_search welcome],
                                     'foreman_puppet/api/v2/environments': %i[index show] },
      resource_type: 'ForemanPuppet::Environment'
    permission :create_environments, { 'foreman_puppet/environments': %i[new create],
                                       'foreman_puppet/api/v2/environments': %i[create] },
      resource_type: 'ForemanPuppet::Environment'
    permission :edit_environments, { 'foreman_puppet/environments': %i[edit update],
                                     'foreman_puppet/api/v2/environments': %i[update] },
      resource_type: 'ForemanPuppet::Environment'
    permission :destroy_environments, { 'foreman_puppet/environments': %i[destroy],
                                        'foreman_puppet/api/v2/environments': %i[destroy] },
      resource_type: 'ForemanPuppet::Environment'
    permission :import_environments, { 'foreman_puppet/environments': %i[import_environments obsolete_and_new],
                                       'foreman_puppet/api/v2/environments': %i[import_puppetclasses] },
      resource_type: 'ForemanPuppet::Environment'
  end

  security_block :puppetclasses do
    permission :view_puppetclasses,   { 'foreman_puppet/puppetclasses' => %i[index show auto_complete_search],
                                        'foreman_puppet/api/v2/puppetclasses' => %i[index show],
                                        'foreman_puppet/api/v2/smart_class_parameters' => %i[index show] },
      resource_type: 'ForemanPuppet::Puppetclass'
    permission :create_puppetclasses, { 'foreman_puppet/puppetclasses' => %i[new create],
                                        'foreman_puppet/api/v2/puppetclasses' => [:create] },
      resource_type: 'ForemanPuppet::Puppetclass'
    permission :edit_puppetclasses,   { 'foreman_puppet/puppetclasses' => %i[edit update override],
                                        'foreman_puppet/api/v2/puppetclasses' => [:update],
                                        'foreman_puppet/api/v2/smart_class_parameters' => %i[create update destroy] },
      resource_type: 'ForemanPuppet::Puppetclass'
    permission :destroy_puppetclasses, { 'foreman_puppet/puppetclasses' => [:destroy],
                                         'foreman_puppet/api/v2/puppetclasses' => [:destroy] },
      resource_type: 'ForemanPuppet::Puppetclass'
    permission :import_puppetclasses, { 'foreman_puppet/puppetclasses' => %i[import_environments obsolete_and_new],
                                        'foreman_puppet/api/v2/environments' => [:import_puppetclasses] },
      resource_type: 'ForemanPuppet::Puppetclass'
    permission :edit_classes, { 'foreman_puppet/api/v2/host_classes': %i[index create destroy] },
      resource_type: 'ForemanPuppet::HostClass'
  end

  add_all_permissions_to_default_roles
  Foreman::Plugin::RbacSupport::AUTO_EXTENDED_ROLES |= ['Site manager']
  add_permissions_to_default_roles(
    'Site manager' => %w[view_puppetclasses import_puppetclasses view_environments import_environments
                         view_external_parameters create_external_parameters edit_external_parameters destroy_external_parameters]
  )

  # add puppet ENC divider
  divider :top_menu, parent: :configure_menu, caption: N_('Puppet ENC')

  # add menu entries
  add_menu_item :top_menu, :environments, caption: N_('Environments'),
                                          engine: ForemanPuppet::Engine,
                                          parent: :configure_menu
  add_menu_item :top_menu, :puppetclasses, caption: N_('Classes'),
                                           engine: ForemanPuppet::Engine,
                                           parent: :configure_menu
  add_menu_item :top_menu, :config_groups, caption: N_('Config Groups'),
                                           engine: ForemanPuppet::Engine,
                                           parent: :configure_menu
  add_menu_item :top_menu, :puppetclass_lookup_keys, caption: N_('Smart Class Parameters'),
                                                     engine: ForemanPuppet::Engine,
                                                     parent: :configure_menu

  register_info_provider(ForemanPuppet::HostInfoProviders::ConfigGroupsInfo)
  register_info_provider(ForemanPuppet::HostInfoProviders::PuppetInfo)

  # register host and hostgroup facet
  register_facet ForemanPuppet::HostPuppetFacet, :puppet do
    configure_host do
      # extend_model ForemanPuppet::Extensions::Host
      api_view list: 'foreman_puppet/api/v2/host_puppet_facets/base',
        single: 'foreman_puppet/api/v2/host_puppet_facets/host_single'
      template_compatibility_properties :environment, :environment_id, :environment_name,
        :puppetclasses, :all_puppetclasses, :puppet_server, :puppet_ca_server
      set_dependent_action :destroy
    end
    configure_hostgroup(ForemanPuppet::HostgroupPuppetFacet) do
      api_view list: 'foreman_puppet/api/v2/hostgroup_puppet_facets/base',
        single: 'foreman_puppet/api/v2/hostgroup_puppet_facets/hostgroup_single'
      template_compatibility_properties :environment, :environment_id, :environment_name,
        :puppet_server, :puppet_ca_server, :puppetca_token
      set_dependent_action :destroy
    end
  end

  add_controller_action_scope('Api::V2::HostsController', :index) do |base_scope|
    base_scope.preload(puppet: :environment)
  end

  unless ForemanPuppet.extracted_from_core?
    Rails.application.config.after_initialize do
      list = Pagelets::Manager.instance.instance_variable_get(:@pagelets)['hosts/_form'][:main_tabs]
      core_pagelet = list.detect { |pagelet| pagelet.opts[:id] == :puppet_klasses }
      list.delete(core_pagelet)
    end
  end

  register_graphql_query_field :environment, 'ForemanPuppet::Types::Environment', :record_field
  register_graphql_query_field :environments, 'ForemanPuppet::Types::Environment', :collection_field
  register_graphql_query_field :puppetclass, 'ForemanPuppet::Types::Puppetclass', :record_field
  register_graphql_query_field :puppetclasses, 'ForemanPuppet::Types::Puppetclass', :collection_field

  extend_template_helpers(ForemanPuppet::TemplateRendererScope)

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

      if ForemanPuppet.extracted_from_core?
        context.add_pagelet :main_tab_fields,
          partial: 'hosts/foreman_puppet/form_main_tab_fields',
          resource_type: resource_type,
          priority: 100
      end
    end
  end
end
