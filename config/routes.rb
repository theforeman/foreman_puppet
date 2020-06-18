Rails.application.routes.draw do
  get 'new_action', to: 'foreman_puppet_enc/hosts#new_action'
  get 'foreman_puppet_enc', to: 'foreman_puppet_enc/react#index'
end
