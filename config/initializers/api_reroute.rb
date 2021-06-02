Foreman::Application.routes.prepend do
  namespace :api, defaults: { format: 'json' } do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v2/, constraints: ApiConstraints.new(version: 2, default: true) do
      resources :puppetclasses, controller: '/foreman_puppet/api/v2/puppetclasses', except: %i[new edit]
      resources :environments, controller: '/foreman_puppet/api/v2/environments', except: %i[new edit]
      resources :hosts, controller: '/foreman_puppet/api/v2/hosts', only: []
      resources :hostgroups, controller: '/foreman_puppet/api/v2/hostgroups', only: %i[]
      resources :config_groups, controller: '/foreman_puppet/api/v2/config_groups', except: %i[new edit]
      resources :smart_class_parameters, controller: '/foreman_puppet/api/v2/smart_class_parameters', except: %i[new edit]
      resources :override_values, controller: '/foreman_puppet/api/v2/override_values', except: %i[new edit]
    end
  end
end
