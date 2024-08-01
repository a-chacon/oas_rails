![Gem Version](https://img.shields.io/gem/v/oas_rails)
![GitHub License](https://img.shields.io/github/license/a-chacon/oas_rails)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/a-chacon/oas_rails/.github%2Fworkflows%2Frubyonrails.yml)

# Open API Specification For Rails

OasRails is a Rails engine for generating **automatic interactive documentation for your Rails APIs**. It generates an **OAS 3.1** document and displays it using **[RapiDoc](https://rapidocweb.com)**.

![Screenshot](https://raw.githubusercontent.com/a-chacon/oas_rails/0cfc9abb5be85e6bb3fc4669e29372be8f80a276/oas_rails_ui.png)

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

## Motivation

After experiencing the interactive documentation in Python's fast-api framework, I sought similar functionality in Ruby on Rails. Unable to find a suitable solution, I [asked on Stack Overflow](https://stackoverflow.com/questions/71947018/is-there-a-way-to-generate-an-interactive-documentation-for-rails-apis) years ago. Now, with some free time while freelancing as an API developer, I decided to build my own tool.

**Note**: This is not yet a production-ready solution. The code may be rough and behave unexpectedly, but I am actively working on improving it. If you like the idea, please consider contributing to its development.

The goal is to minimize the effort required to create comprehensive documentation. By following REST principles in Rails, we believe this is achievable. You can enhance the documentation using [Yard](https://yardoc.org/) tags.

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
  - [Basic Information about the API](#basic-information-about-the-api)
  - [Servers Information](#servers-information)
  - [Tag Information](#tag-information)
  - [Optional Settings](#optional-settings)
  - [Authentication Settings](#authentication-settings)
- [Usage](#usage)
  - [Documenting Your Endpoints](#documenting-your-endpoints)
  - [Example](#example-of-documented-endpoints)
- [Securing the OasRails Engine](#securing-the-oasrails-engine)
- [Customizing the View](#customizing-the-view)
- [Contributing](#contributing)
  - [Roadmap and Ideas for Improvement](#roadmap-and-ideas-for-improvement)
- [License](#license)

## Installation

1. Add this line to your Rails application's Gemfile:

   ```ruby
   gem "oas_rails"`
   ```

2. Execute:

   ```bash
   bundle
   ```

3. Mount the engine in your config/routes.rb file

   ```ruby
   mount OasRails::Engine => '/docs'
   ```

You'll now have **basic documentation** based on your routes and automatically gathered information at `localhost:3000/docs`. To enhance it, create an initializer file and add [Yard](https://yardoc.org/) tags to your controller methods.

## Configuration

To configure OasRails, you MUST create an initializer file including all your settings. The first step is to create your initializer file, which you can easily do with:

```bash
rails generate oas_rails:config
```

Then fill it with your data. Below are the available configuration options:

### Basic Information about the API

- `config.info.title`: The title of your API documentation.
- `config.info.summary`: A brief summary of your API.
- `config.info.description`: A detailed description of your API. This can include markdown formatting and will be displayed prominently in your documentation.
- `config.info.contact.name`: The name of the contact person or organization.
- `config.info.contact.email`: The contact email address.
- `config.info.contact.url`: The URL for more information or support.

### Servers Information

- `config.servers`: An array of server objects, each containing `url` and `description` keys. For more details, refer to the [OpenAPI Specification](https://spec.openapis.org/oas/latest.html#server-object).

### Tag Information

- `config.tags`: An array of tag objects, each containing `name` and `description` keys. For more details, refer to the [OpenAPI Specification](https://spec.openapis.org/oas/latest.html#tag-object).

### Optional Settings

- `config.default_tags_from`: Determines the source of default tags for operations. Can be set to `:namespace` or `:controller`.
- `config.autodiscover_request_body`: Automatically detects request bodies for create/update methods. Default is `true`.
- `config.autodiscover_responses`: Automatically detects responses from controller renders. Default is `true`.
- `config.api_path`: Sets the API path if your API is under a different namespace.

### Authentication Settings

- `config.authenticate_all_routes_by_default`: Determines whether to authenticate all routes by default. Default is `true`.
- `config.security_schema`: The default security schema used for authentication. Choose a predefined security schema from `[:api_key_cookie, :api_key_header, :api_key_query, :basic, :bearer, :bearer_jwt, :mutual_tls]`.
- `config.security_schemas`: Custom security schemas. Follow the [OpenAPI Specification](https://spec.openapis.org/oas/latest.html#security-scheme-object) for defining these schemas.

## Usage

In addition to the information provided in the initializer file and the data that can be extracted from the routes and methods automatically, it is essential to document your API in the following way. The documentation is created **with the help of YARD**, so the methods are documented with **comment tags**.

### Documenting Your Endpoints

Almost every description in an OAS file supports simple markdown. The following tags are available for documenting your endpoints:

<details>
<summary style="font-weight: bold; font-size: 1.2em;">@summary</summary>

**Structure**: `@summary text`

Used to add a summary to the endpoint. It replaces the default summary/title of the endpoint.

**Example**:
`# @summary This endpoint creates a User`

</details>

<details>
<summary style="font-weight: bold; font-size: 1.2em;">@parameter</summary>

**Structure**: `@parameter name(position) [type] text`

Represents a parameter for the endpoint. The position can be: `header`, `path`, `cookie`, or `query`. The type should be a valid Ruby class: `String`, `Integer`, `Array<String>`, etc. Add a `!` after the class to indicate a required parameter.

**Examples**:
`# @parameter page(query) [Integer] The page number.`
`# @parameter slug(path) [String!] Slug of the Project.`

</details>

<details>
<summary style="font-weight: bold; font-size: 1.2em;">@request_body</summary>

**Structure**: `@request_body text [type] structure`

Documents the request body needed by the endpoint. The structure is optional if you provide a valid Active Record class. Use `!` to indicate a required request body.

**Example**:
`# @request_body The user to be created [Hash] {user: {name: String, age: Integer, password: String}}`

</details>

<details>
<summary style="font-weight: bold; font-size: 1.2em;">@request_body_example</summary>

**Structure**: `@request_body_example text [type] structure`

Adds examples to the provided request body.

**Example**:
`# @request_body_example A complete User. [Hash] {user: {name: 'Luis', age: 30, password: 'MyWeakPassword123'}}`

</details>

<details>
<summary style="font-weight: bold; font-size: 1.2em;">@response</summary>

**Structure**: `@response text(code) [type] structure`

Documents the responses of the endpoint and overrides the default responses found by the engine.

**Example**:
`# @response User not found by the provided Id(404) [Hash] {success: Boolean, message: String}`

</details>

<details>
<summary style="font-weight: bold; font-size: 1.2em;">@tag</summary>

**Structure**: `@tag text`

Tags your endpoints. You can complete the tag documentation in the initializer file by defining these tags beforehand. It's not necessary for the tag to exist in your initializer file before use.

**Example**:
`# @tag Users`

</details>

<details>
<summary style="font-weight: bold; font-size: 1.2em;">@no_auth</summary>

**Structure**: `@no_auth`

This tag will remove any security requirement from the endpoint. Useful when most of your endpoints require authentication and only a few do not.(Ex: Login, Registration...)

**Example**:
`# @no_auth`

</details>

<details>
<summary style="font-weight: bold; font-size: 1.2em;">@auth</summary>

**Structure**: `@auth [types]`

This tag will set which security mechanisms can be used for the endpoint. The security mechanisms MUST be defined previously in the initializer file.

**Example**:
`# @auth [bearer, basic]`

</details>

You can use these tags in your controller methods to enhance the automatically generated documentation. Remember to use markdown formatting in your descriptions for better readability in the generated OAS document.

### Example of documented endpoints

```ruby
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  # @summary Returns a list of Users.
  #
  # @parameter offset(query) [Integer]  Used for pagination of response data (default: 25 items per response). Specifies the offset of the next block of data to receive.
  # @parameter status(query) [Array<String>]   Filter by status. (e.g. status[]=inactive&status[]=deleted).
  # @parameter X-front(header) [String] Header for identify the front.
  def index
    @users = User.all
  end

  # @summary Get a user by id.
  # @auth [bearer]
  #
  # This method show a User by ID. The id must exist of other way it will be returning a **`404`**.
  #
  # @parameter id(path) [Integer] Used for identify the user.
  # @response Requested User(200) [Hash] {user: {name: String, email: String, created_at: DateTime }}
  # @response User not found by the provided Id(404) [Hash] {success: Boolean, message: String}
  # @response You don't have the right permission for access to this resource(403) [Hash] {success: Boolean, message: String}
  def show
    render json: @user
  end

  # @summary Create a User
  # @no_auth
  #
  # @request_body The user to be created. At least include an `email`. [User!]
  # @request_body_example basic user [Hash] {user: {name: "Luis", email: "luis@gmail.ocom"}}
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { success: false, errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # A `user` can be updated with this method
  # - There is no option
  # - It must work
  # @tags users, update
  # @request_body User to be created [Hash] {user: { name: String, email: String, age: Integer}}
  # @request_body_example Update user [Hash] {user: {name: "Luis", email: "luis@gmail.com"}}
  # @request_body_example Complete User [Hash] {user: {name: "Luis", email: "luis@gmail.com", age: 21}}
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # @summary Delete a User
  # Delete a user and his associated data.
  def destroy
    @user.destroy!
    redirect_to users_url, notice: 'User was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
```

## Securing the OasRails Engine

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

## Customizing the View

The OasRails engine provides an easy way to display your OpenAPI Specification (OAS) within your Rails application. By default, it includes an `index` view in the `OasRailsController` that displays [RapiDoc](https://rapidocweb.com/) through a CDN with default configurations. You can easily override this view to replace RapiDoc entirely or configure it differently.

#### Overriding the `index` View

To override the `index` view provided by the OasRails engine, follow these steps:

1. **Create the Override View File**: In your host application, create a new file at the path `app/views/oas_rails/oas_rails/index.html.erb`. If the directories do not exist, you will need to create them.

2. **Customize the View**: Open the newly created `index.html.erb` file and add your custom HTML and ERB code to display the OAS as desired. You can refer to the source code of this project for guidance.

#### Using the Custom View

Once the custom view file is in place, Rails will automatically use it instead of the view provided by the OasRails engine. This allows you to fully customize the presentation of the OAS without modifying the engine's code.

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement". Don't forget to give the project a star⭐! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Roadmap and Ideas for Improvement

- Clean, document and structure the code
- [x] Support documentation of authentication methods
- Define Global Tags/Configuration (e.g., common responses like 404 errors)
- Post-process the JSON and replace common objects with references to components
- Create a temporary file with the JSON in production mode to avoid rebuilding it on every request
- Create tags for popular gems used in APIs (e.g., a `@pagy` tag for common pagination parameters)
- [x] Add basic authentication to OAS and UI for security reasons (Solution documented, not need to be managed by the engine)
- Implement ability to define OAS by namespaces (e.g., generate OAS for specific routes like `/api` or separate versions V1 and V2)

## License

The gem is available as open source under the terms of the [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html#license-text).
