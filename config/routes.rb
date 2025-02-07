Rails.application.routes.draw do  
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  devise_for :admin_users, ActiveAdmin::Devise.config.merge(path: 'admin', path_names: { sign_in: 'login' })

  ActiveAdmin.routes(self)

  mount ActionCable.server => '/cable'

  get "up" => "rails/health#show", as: :rails_health_check
  get 'validate_token', to: 'token_auth#validate'

  resources :categories

  resources :products do
    collection do
      get 'search', to: 'products#search'
      get 'filter', to: 'products#filter'
    end

    resources :chats
  end

  get 'get_all_chats', to: 'chats#get_all_chats'

  resources :category_products do
    collection do
      get :'category_products_with_multiple_category_ids', to: 'category_products#category_products_with_multiple_category_ids'
    end
  end

  resources :cart_items

  resources :vouchers

  post 'validate_voucher', to: 'vouchers#validate'
  get 'token_auth/validate'

end
