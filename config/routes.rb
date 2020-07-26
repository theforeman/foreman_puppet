ForemanPuppetEnc::Engine.routes.draw do
  get 'new_action', to: 'foreman_puppet_enc/hosts#new_action'
  get 'foreman_puppet_enc', to: 'foreman_puppet_enc/react#index'
  resources :config_groups, except: [:show] do
    collection do
      get 'help', action: :welcome
      get 'auto_complete_search'
    end
  end

  namespace :api, defaults: { format: 'json' } do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/, constraints: ApiConstraints.new(version: 2, default: true) do
      get 'new_action', to: 'foreman_puppet_enc/api/v2/hosts#new_action'
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanPuppetEnc::Engine, at: '/foreman_puppet_enc'
end
