Rails.application.routes.draw do
  devise_for :users

  root to: 'accounts#index'

  resources :accounts do
    resources :transactions, only: %i[index new create]
    get '/ofx_import', to: 'accounts#ofx_import'
    post '/ofx_import', to: 'accounts#ofx_import_to_account'
  end

  resources :categories do
    resources :subcategories, only: %i[index new create]
  end

  resources :statistics, only: [:index]
  resources :transactions, only: %i[show edit update destroy]
  resources :subcategories, only: %i[edit update destroy]
end
