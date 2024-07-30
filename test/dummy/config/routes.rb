Rails.application.routes.draw do
  post '/users/login', to: 'users#login'
  resources :users, shallow: true do
    resources :projects
  end
  mount OasRails::Engine => '/docs'
end
