# Securing the OasRails Engine

To secure the OasRails engine, which exposes an endpoint for showing the OAS definition, you can configure authentication to ensure that only authorized users have access. Here are a few methods to achieve this:

### 1. Using Basic Authentication

Use basic authentication to protect the OasRails endpoint. You can set this up in an initializer:

```ruby
# config/initializers/oas_rails.rb
OasRails::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
  ActiveSupport::SecurityUtils.secure_compare(Rails.application.credentials.oas_rails_username, username) &
    ActiveSupport::SecurityUtils.secure_compare(Rails.application.credentials.oas_rails_password, password)
end
```

### 2. Using Devise's `authenticate` Helper

You can use Devise's `authenticate` helper to restrict access to the OasRails endpoint. For example, you can allow only admin users to access the endpoint:

```ruby
# config/routes.rb
# ...
authenticate :user, ->(user) { user.admin? } do
  mount OasRails::Engine, at: '/docs'
end
```

### 3. Custom Authentication

To support custom authentication, you can extend the OasRails' ApplicationController using a hook. This allows you to add custom before actions to check for specific user permissions:

```ruby
# config/initializers/oas_rails.rb

ActiveSupport.on_load(:oas_rails_application_controller) do
  # context here is OasRails::ApplicationController

  before_action do
    raise ActionController::RoutingError.new('Not Found') unless current_user&.admin?
  end

  def current_user
    # Load the current user
    User.find(session[:user_id]) # Adjust according to your authentication logic
  end
end
```
