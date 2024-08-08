Rails.application.routes.draw do
  get 'token_auth/validate'
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "up" => "rails/health#show", as: :rails_health_check
  get 'validate_token', to: 'token_auth#validate'

  resources :categories
  resources :products


end
