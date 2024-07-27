Rails.application.routes.draw do
  resources :users, shallow: true do
    resources :projects
  end
  mount OasRails::Engine => '/docs'
end
