OasRails::Engine.routes.draw do
  root 'oas_rails#index'
  get '/oas', to: 'oas_rails#oas'
end
