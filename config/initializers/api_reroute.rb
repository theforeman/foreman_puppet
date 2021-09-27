Foreman::Application.routes.prepend do
  namespace :api, defaults: { format: 'json' } do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v2/, constraints: ApiConstraints.new(version: 2, default: true) do
      resources :smart_proxies, only: [] do
        post :import_puppetclasses, on: :member
        resources :environments, only: [] do
          post :import_puppetclasses, on: :member, controller: '/foreman_puppet/api/v2/environments'
        end
      end

      resources :config_groups, controller: '/foreman_puppet/api/v2/config_groups', except: %i[new edit]

      resources :hosts, only: [] do
        resources :puppetclasses, controller: '/foreman_puppet/api/v2/puppetclasses', except: %i[new edit]
        resources :smart_class_parameters, controller: '/foreman_puppet/api/v2/smart_class_parameters', except: %i[new edit create] do
          resources :override_values, controller: '/foreman_puppet/api/v2/override_values', except: %i[new edit]
        end
        resources :host_classes, path: :puppetclass_ids, controller: '/foreman_puppet/api/v2/host_classes', only: %i[index create destroy]
      end

      resources :hostgroups, only: [] do
        resources :puppetclasses, controller: '/foreman_puppet/api/v2/puppetclasses', except: %i[new edit]
        resources :smart_class_parameters, controller: '/foreman_puppet/api/v2/smart_class_parameters', except: %i[new edit create] do
          resources :override_values, controller: '/foreman_puppet/api/v2/override_values', except: %i[new edit]
        end
        resources :hostgroup_classes, path: :puppetclass_ids, controller: '/foreman_puppet/api/v2/hostgroup_classes', only: %i[index create destroy]
      end

      resources :environments, controller: '/foreman_puppet/api/v2/environments', except: %i[new edit] do
        resources :locations, only: %i[index show]
        resources :organizations, only: %i[index show]
        resources :smart_proxies, only: [] do
          post :import_puppetclasses, on: :member
        end
        resources :smart_class_parameters, controller: '/foreman_puppet/api/v2/smart_class_parameters', except: %i[new edit create] do
          resources :override_values, controller: '/foreman_puppet/api/v2/override_values', except: %i[new edit]
        end
        resources :puppetclasses, controller: '/foreman_puppet/api/v2/puppetclasses', except: %i[new edit] do
          resources :smart_class_parameters, controller: '/foreman_puppet/api/v2/smart_class_parameters', except: %i[new edit create] do
            resources :override_values, controller: '/foreman_puppet/api/v2/override_values', except: %i[new edit destroy]
          end
        end
        resources :hosts, only: %i[index show]
        resources :template_combinations, only: %i[index show create update]
      end

      resources :puppetclasses, controller: '/foreman_puppet/api/v2/puppetclasses', except: %i[new edit] do
        resources :smart_class_parameters, controller: '/foreman_puppet/api/v2/smart_class_parameters', except: %i[new edit create] do
          resources :override_values, controller: '/foreman_puppet/api/v2/override_values', except: %i[new edit]
        end
        resources :environments, controller: '/foreman_puppet/api/v2/environments', only: %i[index show] do
          resources :smart_class_parameters, controller: '/foreman_puppet/api/v2/smart_class_parameters', except: %i[new edit create] do
            resources :override_values, controller: '/foreman_puppet/api/v2/override_values', except: %i[new edit]
          end
        end
      end

      resources :smart_class_parameters, controller: '/foreman_puppet/api/v2/smart_class_parameters', except: %i[new edit create destroy] do
        resources :override_values, controller: '/foreman_puppet/api/v2/override_values', except: %i[new edit]
      end

      resources :override_values, controller: '/foreman_puppet/api/v2/override_values', except: %i[new edit]

      resources :locations, only: [] do
        resources :environments, controller: '/foreman_puppet/api/v2/environments', only: %i[index show]

        resources :organizations, only: [] do
          resources :environments, controller: '/foreman_puppet/api/v2/environments', only: %i[index show]
        end
      end

      resources :organizations, only: [] do
        resources :environments, controller: '/foreman_puppet/api/v2/environments', only: %i[index show]

        resources :locations, only: [] do
          resources :environments, controller: '/foreman_puppet/api/v2/environments', only: %i[index show]
        end
      end
    end
  end
end
