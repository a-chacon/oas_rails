Rails.application.routes.draw do
  post '/users/login', to: 'users#login'
  get "/users/new", to: "users#new" # This route is for testing purpose
  resources :users, shallow: true do
    resources :projects
  end
  match 'users', to: 'users#index', via: [:get, :post]
  mount OasRails::Engine => '/docs'
end
