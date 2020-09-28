ForemanPuppetEnc::Engine.routes.draw do
  resources :config_groups, except: [:show] do
    collection do
      get 'help', action: :welcome
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

  namespace :api, defaults: { format: 'json' } do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/, constraints: ApiConstraints.new(version: 2, default: true) do
      constraints(:id => /[^\/]+/) do
        resources :hosts, :only => [] do
          resources :smart_class_parameters, except: %i[new edit create]
        end

        resources :hostgroup, only: [] do
          resources :smart_class_parameters, except: %i[new edit create]
        end

        resources :environments, :only => [] do
          resources :smart_class_parameters, except: %i[new edit create]
        end

        resources :puppetclasses, :only => [] do
          resources :smart_class_parameters, except: %i[new edit create]
          resources :environments, :only => [] do
            resources :smart_class_parameters, except: %i[new edit create]
          end
        end

        resources :smart_class_parameters, :except => [:new, :edit, :create, :destroy]
      end
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanPuppetEnc::Engine, at: '/foreman_puppet_enc'
end
