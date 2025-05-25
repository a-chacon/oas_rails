Rage.routes.draw do
  root to: ->(_env) { [200, {}, "It works!"] }
  resources :users
  resources :projects

  mount OasRails::Web::View => "/docs"
end
