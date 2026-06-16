Rails.application.routes.draw do
  post '/users/login', to: 'users#login'
  get "/users/new", to: "users#new" # This route is for testing purpose

  resources :users, shallow: true do
    resources :projects
    resource :avatar, only: [:update], controller: 'users/avatar'
  end

  match 'users', to: 'users#index', via: [:get, :options]
  resources :typed, only: [:index, :show]

  # Example resources for the experimental API used to test multiple OAS mounts
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  namespace :admin do
    resources :reports, only: [:index]
  end

  # Mount the OasRails engine twice with different configurations
  mount OasRails::Engine => '/api/docs', default: { configuration: 'public' }, as: 'public_oas'
  mount OasRails::Engine => '/internal/api/docs', default: { configuration: 'internal' }, as: 'internal_oas'
end
