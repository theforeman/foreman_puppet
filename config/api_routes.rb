ForemanPuppet::Engine.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/, constraints: ApiConstraints.new(version: 2, default: true) do
      constraints(id: %r{[^/]+}) do
        resources :smart_proxies, only: [] do
          post :import_puppetclasses, on: :member, controller: 'environments'

          resources :environments, only: [] do
            post :import_puppetclasses, on: :member
          end
        end

        resources :config_groups, except: %i[new edit]

        resources :hosts, only: [] do
          resources :puppetclasses, except: %i[new edit]
          resources :smart_class_parameters, except: %i[new edit create] do
            resources :override_values, except: %i[new edit]
          end
          resources :host_classes, path: :puppetclass_ids, only: %i[index create destroy]
        end

        resources :hostgroups, only: [] do
          resources :puppetclasses, except: %i[new edit]
          resources :smart_class_parameters, except: %i[new edit create] do
            resources :override_values, except: %i[new edit]
          end
          resources :hostgroup_classes, path: :puppetclass_ids, only: %i[index create destroy]
        end

        resources :environments, except: %i[new edit] do
          resources :locations, only: %i[index show], controller: '/api/v2/locations'
          resources :organizations, only: %i[index show], controller: '/api/v2/organizations'
          resources :smart_proxies, only: [] do
            post :import_puppetclasses, on: :member, controller: 'environments'
          end
          resources :smart_class_parameters, except: %i[new edit create] do
            resources :override_values, except: %i[new edit]
          end
          resources :puppetclasses, except: %i[new edit] do
            resources :smart_class_parameters, except: %i[new edit create] do
              resources :override_values, except: %i[new edit destroy]
            end
          end
          resources :hosts, only: %i[index show], controller: '/api/v2/hosts'
          resources :template_combinations, only: %i[index], controller: '/api/v2/template_combinations'
        end

        resources :puppetclasses, except: %i[new edit] do
          resources :smart_class_parameters, except: %i[new edit create] do
            resources :override_values, except: %i[new edit]
          end
          resources :environments, only: %i[index show] do
            resources :smart_class_parameters, except: %i[new edit create] do
              resources :override_values, except: %i[new edit]
            end
          end
        end

        resources :smart_class_parameters, except: %i[new edit create destroy] do
          resources :override_values, except: %i[new edit]
        end

        resources :override_values, only: %i[update destroy]

        resources :locations, only: [] do
          resources :environments, only: %i[index show]

          resources :organizations, only: [] do
            resources :environments, only: %i[index show]
          end
        end

        resources :organizations, only: [] do
          resources :environments, only: %i[index show]

          resources :locations, only: [] do
            resources :environments, only: %i[index show]
          end
        end
      end
    end
  end
end
