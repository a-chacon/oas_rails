OasRails::Engine.routes.draw do
  get '(.:format)', to: 'oas_rails#index'
end
