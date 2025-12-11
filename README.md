![Gem Version](https://img.shields.io/gem/v/oas_rails?color=E9573F)
![GitHub License](https://img.shields.io/github/license/a-chacon/oas_rails?color=blue)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/a-chacon/oas_rails/.github%2Fworkflows%2Frubyonrails.yml)
![Gem Total Downloads](https://img.shields.io/gem/dt/oas_rails)
![Static Badge](https://img.shields.io/badge/Rails-%3E%3D7.0.0-%23E9573F)
![Static Badge](https://img.shields.io/badge/Ruby-%3E%3D3.1.0-%23E9573F)

# 📃Open API Specification For Rails

OasRails is a Rails engine for generating **automatic interactive documentation for your Rails APIs**. It generates an **OAS 3.1** document and displays it using **[RapiDoc](https://rapidocweb.com)**.

It relies on the [OasCore](https://github.com/a-chacon/oas_core) gem.

### 🚀 Demo App

Explore the interactive documentation live:

🔗 **[Open Demo App](https://paso.fly.dev/api/docs)**  
👤 **Username**: `oasrails`  
🔑 **Password**: `oasrails`

🎬 A Demo Installation/Usage Video:
<https://vimeo.com/1013687332>
🎬

![Screenshot](https://a-chacon.github.io/oas_core/assets/rails_theme.png)

## Related Projects

- **[ApiPie](https://github.com/Apipie/apipie-rails)**: Doesn't support OAS 3.1, requires learning a DSL, lacks a nice UI
- **[swagger_yard-rails](https://github.com/livingsocial/swagger_yard-rails)**: Seems abandoned, but serves as inspiration
- **[Rswag](https://github.com/rswag/rswag)**: Not automatic, depends on RSpec; Many developers now use Minitest as it's the default test framework
- **[grape-swagger](https://github.com/ruby-grape/grape-swagger)**: Requires Grape
- **[rspec_api_documentation](https://github.com/zipmark/rspec_api_documentation)**: Requires RSpec and a command to generate the docs

## What Sets OasRails Apart?

- **Dynamic**: No command required to generate docs
- **Simple**: Complement default documentation with a few comments; no need to learn a complex DSL
- **Pure Ruby on Rails APIs**: No additional frameworks needed (e.g., Grape, RSpec)

## Installation

### 1. Add the gem to your Gemfile

```ruby
gem 'oas_rails'
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Mount the engine in your routes

```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount OasRails::Engine => '/docs'

  # Your API routes...
end
```

### 4. Access your documentation

Start your Rails server and navigate to `http://localhost:3000/docs`. You'll have basic documentation generated automatically from your routes!

## Configuration

Generate an initializer to customize your documentation:

```bash
rails generate oas_rails:config
```

This creates `config/initializers/oas_rails.rb`. Here's an example with common options:

```ruby
# config/initializers/oas_rails.rb
OasRails.configure do |config|
  # Basic Information
  config.info.title = 'My API'
  config.info.version = '1.0.0'
  config.info.summary = 'A brief summary of your API'
  config.info.description = <<~HEREDOC
    # Welcome to My API

    This is a **markdown** description of your API.
  HEREDOC
  config.info.contact.name = 'API Support'
  config.info.contact.email = 'support@example.com'
  config.info.contact.url = 'https://example.com'

  # Servers
  config.servers = [
    { url: 'http://localhost:3000', description: 'Development' },
    { url: 'https://api.example.com', description: 'Production' }
  ]

  # Tags (for grouping endpoints)
  config.tags = [
    { name: 'Users', description: 'User management endpoints' },
    { name: 'Posts', description: 'Blog post operations' }
  ]

  # Extract default tags from :namespace or :controller
  config.default_tags_from = :namespace

  # Authentication - use a predefined schema
  # Options: :api_key_cookie, :api_key_header, :api_key_query,
  #          :basic, :bearer, :bearer_jwt, :mutual_tls
  config.security_schema = :bearer

  # Theme for RapiDoc UI
  # Available: :rails, :light, :dark, :night, :forest, :snow, and more
  config.rapidoc_theme = :rails

  # Automatically add common error responses (404, 401, 403, 500, 422)
  config.set_default_responses = true
end
```

> For complete configuration options, see the [OasCore MDBook](https://a-chacon.github.io/oas_core).

## Usage: Documenting Your Endpoints

Use YARD-style comments above your controller actions to enhance the documentation.

### Available Tags

| Tag | Description | Example |
|-----|-------------|---------|
| `@summary` | Short endpoint description | `# @summary Get user by ID` |
| `@tags` | Categorize endpoint | `# @tags Users, Admin` |
| `@parameter` | Document parameters | `# @parameter id(path) [!Integer] User ID` |
| `@request_body` | Describe request body | `# @request_body User data [!User]` |
| `@response` | Document responses with body | `# @response Success(200) [User]` |
| `@response_status` | Document responses without body | `# @response_status 204` |
| `@no_auth` | Mark as public endpoint | `# @no_auth` |
| `@auth` | Specify auth methods | `# @auth [bearer, basic]` |

### @parameter Syntax

```
@parameter name(location) [Type] Description keyword: (value)
```

- **location**: `query`, `path`, `header`, or `cookie`
- **Type**: Use `!` prefix for required (e.g., `[!Integer]`)
- **Keywords**: `default`, `minimum`, `maximum`, `enum`, `format`, `pattern`

```ruby
# @parameter id(path) [!Integer] The user ID
# @parameter page(query) [Integer] Page number. default: (1) minimum: (1)
# @parameter status(query) [String] Filter by status. enum: (active,inactive,pending)
```

### @request_body Syntax

```ruby
# Simple - reference a model
# @request_body Create a new user [!User]

# With structure
# @request_body Create a post [!Hash{ title: String, content: String }]

# With example
# @request_body_example Basic User
#   [JSON
#   {
#     "user": {
#       "name": "John",
#       "email": "john@example.com"
#     }
#   }
#   ]
```

### @response Syntax

```ruby
# @response Success(200) [User]
# @response Not found(404) [Hash{ message: String }]
# @response Validation errors(422) [Hash{ errors: Array<String> }]
```

## Complete Controller Example

```ruby
# app/controllers/api/v1/users_controller.rb
class Api::V1::UsersController < ApplicationController
  before_action :authenticate!, except: [:create, :index]
  before_action :set_user, only: [:show, :update, :destroy]

  # @summary List all users
  # @tags Users
  # @parameter page(query) [Integer] Page number. default: (1)
  # @parameter status(query) [String] Filter by status. enum: (active,inactive)
  # @response List of users(200) [Array<User>]
  def index
    @users = User.all
    render json: @users
  end

  # @summary Get user by ID
  # @tags Users
  # @parameter id(path) [!Integer] The user ID
  # @response User found(200) [User]
  # @response User not found(404) [Hash{ message: String }]
  def show
    render json: @user
  end

  # @summary Create a new user
  # @tags Users
  # @no_auth
  # @request_body User data [!Hash{ user: Hash{ name: String, email: !String, password: !String } }]
  # @request_body_example New User
  #   [JSON
  #   {
  #     "user": {
  #       "name": "John Doe",
  #       "email": "john@example.com",
  #       "password": "secure123"
  #     }
  #   }
  #   ]
  # @response User created(201) [User]
  # @response Validation errors(422) [Hash{ errors: Array<String> }]
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # @summary Update user
  # @tags Users
  # @parameter id(path) [!Integer] The user ID
  # @request_body Updated user data [Hash{ user: Hash{ name: String, email: String } }]
  # @response User updated(200) [User]
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # @summary Delete user
  # @tags Users
  # @parameter id(path) [!Integer] The user ID
  # @response_status 204
  def destroy
    @user.destroy
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
```

## Customization

### Available Themes

```ruby
config.rapidoc_theme = :rails  # Default Rails-styled theme
```

**Light themes**: `:light`, `:snow`, `:green`, `:blue`, `:beige`

**Dark themes**: `:dark`, `:night`, `:mud`, `:cofee`, `:forest`, `:olive`, `:outerspace`, `:ebony`

**With nav styling**: `:graynav`, `:purplenav`, `:lightgraynav`, `:darkbluenav`

### Custom RapiDoc Settings

```ruby
config.rapidoc_configuration = {
  'show-header' => 'true',
  'heading-text' => 'My API Docs'
}

# Add a custom logo
config.rapidoc_logo_url = 'https://example.com/logo.png'
```

### Include Modes

```ruby
# :all - Include all endpoints (default)
# :with_tags - Only endpoints with @tags
# :explicit - Only endpoints with @oas_include tag
config.include_mode = :all
```

## Full Documentation

For complete documentation including all tags, advanced configuration, and more examples, please refer to the [OasCore MDBook](https://a-chacon.github.io/oas_core).

## 📽️ Motivation

After experiencing the interactive documentation in Python's fast-api framework, I sought similar functionality in Ruby on Rails. Unable to find a suitable solution, I [asked on Stack Overflow](https://stackoverflow.com/questions/71947018/is-there-a-way-to-generate-an-interactive-documentation-for-rails-apis) years ago. Now, with some free time while freelancing as an API developer, I decided to build my own tool.

**Note: This is not yet a production-ready solution. The code may be rough and behave unexpectedly, but I am actively working on improving it. If you like the idea, please consider contributing to its development.**

The goal is to minimize the effort required to create comprehensive documentation. By following REST principles in Rails, we believe this is achievable. You can enhance the documentation using [Yard](https://yardoc.org/) tags.

## Documentation

For see how to install, configure and use OasRails please refere to the [OasCore MDBook](https://a-chacon.github.io/oas_core)

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement". Don't forget to give the project a star⭐! Thanks again!

If you plan a big feature, first open an issue to discuss it before any development.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

OasRails is released under the [MIT License](https://opensource.org/licenses/MIT).

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=a-chacon/oas_rails&type=Date)](https://www.star-history.com/#a-chacon/oas_rails&Date)
