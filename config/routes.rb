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

  resources :hosts, only: [], controller: '/hosts' do
    collection do
      post 'hostgroup_or_environment_selected'
      post 'puppetclass_parameters'
      match 'select_multiple_environment', via: %i[get post]
      post 'update_multiple_environment'
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
