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
      constraints(id: %r{[^/]+}) do
        resources :config_groups, except: %i[new edit]

        resources :hosts, only: [] do
          resources :smart_class_parameters, except: %i[new edit create] do
            resources :override_values, except: %i[new edit]
          end
        end

        resources :hostgroup, only: [] do
          resources :smart_class_parameters, except: %i[new edit create] do
            resources :override_values, except: %i[new edit]
          end
        end

        resources :environments, only: [] do
          resources :smart_class_parameters, except: %i[new edit create] do
            resources :override_values, except: %i[new edit]
          end
          resources :puppetclasses, only: [] do
            resources :smart_class_parameters, except: %i[new edit create] do
              resources :override_values, except: %i[new edit destroy]
            end
          end
        end

        resources :puppetclasses, only: [] do
          resources :smart_class_parameters, except: %i[new edit create] do
            resources :override_values, except: %i[new edit]
          end
          resources :environments, only: [] do
            resources :smart_class_parameters, except: %i[new edit create] do
              resources :override_values, except: %i[new edit]
            end
          end
        end

        resources :smart_class_parameters, except: %i[new edit create destroy] do
          resources :override_values, except: %i[new edit]
        end

        resources :override_values, only: %i[update destroy]
      end
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanPuppetEnc::Engine, at: '/foreman_puppet_enc'
end
