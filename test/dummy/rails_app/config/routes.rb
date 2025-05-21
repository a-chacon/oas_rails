Rails.application.routes.draw do
  resources :projects
  resources :users

  mount OasRails::Web::View => "/docs"
end
