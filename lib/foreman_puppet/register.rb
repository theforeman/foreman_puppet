Foreman::Plugin.register :foreman_puppet do
  requires_foreman '>= 3.5.0'
  # Add Global JS file for extending foreman-core components and routes
  register_global_js_file 'global'

  settings do
    category(:facts, N_('Facts')) do
      setting('default_puppet_environment',
        type: :string,
        description: N_('Foreman will default to this puppet environment if it cannot auto detect one'),
        default: 'production',
        full_name: N_('Default Puppet environment'),
        collection: proc { ForemanPuppet::Environment.pluck(:name).map { |name| [name, name] }.to_h })
      setting('enc_environment',
        type: :boolean,
        description: N_('Foreman will explicitly set the puppet environment in the ENC yaml output. '\
                        'This will avoid conflicts between the environment in puppet.conf and the environment set in Foreman'),
        default: true,
        full_name: N_('ENC environment'))
      setting('update_environment_from_facts',
        type: :boolean,
        description: N_("Foreman will update a host's environment from its facts"),
        default: false,
        full_name: N_('Update environment from facts'))
    end

    category(:cfgmgmt, N_('Config Management')) do
      setting('puppet_interval',
        type: :integer,
        description: N_('Duration in minutes after servers reporting via Puppet are classed as out of sync.'),
        default: 35,
        full_name: N_('Puppet interval'))
      setting('puppet_out_of_sync_disabled',
        type: :boolean,
        description: N_('Disable host configuration status turning to out of sync for %s after report does not arrive within configured interval') % 'Puppet',
        default: false,
        full_name: N_('%s out of sync disabled') % 'Puppet')
    end
  end

  apipie_documented_controllers(["#{ForemanPuppet::Engine.root}/app/controllers/foreman_puppet/api/v2/*.rb"])

  # TODO: maybe this would not be necessary if we rething the form
  %i[create_hostgroups edit_hostgroups].each do |perm|
    p = Foreman::AccessControl.permission(perm)
    p.actions << 'hostgroups/environment_selected'
    p.actions << 'hostgroups/puppetclass_parameters'
    p.actions << 'foreman_puppet/puppetclasses/parameters'
  end
  p = Foreman::AccessControl.permission(:edit_hostgroups)
  %w[index create destroy].each do |action|
    p.actions << "foreman_puppet/api/v2/hostgroup_classes/#{action}"
  end
  %i[create_hosts edit_hosts].each do |perm|
    p = Foreman::AccessControl.permission(perm)
    p.actions << 'hosts/hostgroup_or_environment_selected'
    p.actions << 'hosts/puppetclass_parameters'
    if perm == :edit_hosts
      p.actions << 'hosts/select_multiple_environment'
      p.actions << 'hosts/update_multiple_environment'
      p.actions << 'hosts/select_multiple_puppet_proxy'
      p.actions << 'hosts/update_multiple_puppet_proxy'
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
                                        'foreman_puppet/api/v2/environments' => [:import_puppetclasses],
                                        'api/v2/smart_proxies' => [:import_puppetclasses] },
      resource_type: 'ForemanPuppet::Puppetclass'
    permission :edit_classes, { :host_editing => [:edit_classes],
                                'foreman_puppet/api/v2/host_classes' => %i[index create destroy] },
      resource_type: 'ForemanPuppet::HostClass'
  end

  add_all_permissions_to_default_roles
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
      api_view list: 'foreman_puppet/api/v2/host_puppet_facets/host_list',
        single: 'foreman_puppet/api/v2/host_puppet_facets/host_single'
      template_compatibility_properties :environment, :environment_id, :environment_name
      set_dependent_action :destroy
    end
    configure_hostgroup(ForemanPuppet::HostgroupPuppetFacet) do
      api_view list: 'foreman_puppet/api/v2/hostgroup_puppet_facets/hostgroup_list',
        single: 'foreman_puppet/api/v2/hostgroup_puppet_facets/hostgroup_single'
      template_compatibility_properties :environment, :environment_id, :environment_name
      set_dependent_action :destroy
    end
  end

  add_controller_action_scope('Api::V2::HostsController', :index) do |base_scope|
    base_scope.preload(puppet: :environment)
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

      context.add_pagelet :main_tab_fields,
        partial: 'hosts/foreman_puppet/form_main_tab_fields',
        resource_type: resource_type,
        priority: 100
    end
  end
  extend_page 'hosts/_list' do |context|
    context.with_profile :puppet, _('Puppet'), default: true do
      add_pagelet :hosts_table_column_header, key: :environment, label: s_('Environment name'), sortable: true, width: '10%', class: 'hidden-xs'
      add_pagelet :hosts_table_column_content, key: :environment, callback: ->(host) { host.environment }, class: 'hidden-xs ellipsis'
    end
  end
end
