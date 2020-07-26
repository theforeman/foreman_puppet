ForemanPuppetEnc::Engine.routes.draw do
  resources :config_groups, :except => [:show] do
    collection do
      get 'help', :action => :welcome
      get 'auto_complete_search'
    end
  end

  namespace :api, defaults: { format: 'json' } do
    scope '(:apiv)', module: :v2, defaults: { apiv: 'v2' }, apiv: /v1|v2/, constraints: ApiConstraints.new(version: 2, default: true) do
      resources :config_groups
    end
  end
end

Foreman::Application.routes.draw do
  mount ForemanPuppetEnc::Engine, at: '/foreman_puppet_enc'
end
