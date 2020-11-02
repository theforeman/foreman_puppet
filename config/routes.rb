ForemanPuppetEnc::Engine.routes.draw do
  resources :config_groups, except: [:show] do
    collection do
      get 'help', action: :welcome
      get 'auto_complete_search'
    end
  end

  resources :environments, except: [:show] do
    collection do
      get 'help', action: :welcome
      get 'import_environments'
      post 'obsolete_and_new'
      get 'auto_complete_search'
    end
  end

  constraints(id: %r{[^/]+}) do
    resources :puppetclass_lookup_keys, except: %i[show new create] do
      collection do
        get 'help', action: :welcome
        get 'auto_complete_search'
      end
    end
  end

  resources :puppetclasses, except: %i[new create show] do
    collection do
      get 'import_environments'
      post 'obsolete_and_new'
      get 'auto_complete_search'
    end
    member do
      post 'parameters'
      post 'override'
    end
    constraints(id: %r{[^/]+}) do
      resources :hosts, controller: '/hosts'
    end
  end

  resources :puppet_smart_proxies, only: [] do
    member do
      get 'environments'
      get 'dashboard'
    end
  end

  # TODO: should we patch the core routes?
  resources :hosts, only: [], controller: '/hosts' do
    collection do
      post 'hostgroup_or_environment_selected'
      post 'puppetclass_parameters'
      match 'select_multiple_environment', via: %i[get post]
      post 'update_multiple_environment'
      post 'select_multiple_puppet_proxy'
      post 'update_multiple_puppet_proxy'
    end

    constraints(host_id: %r{[^/]+}) do
      resources :puppetclasses, only: :index
    end
  end

  resources :hostgroups, only: [], controller: '/hostgroups' do
    collection do
      post 'environment_selected'
      post 'puppetclass_parameters'
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanPuppetEnc::Engine, at: '/foreman_puppet_enc'
end
