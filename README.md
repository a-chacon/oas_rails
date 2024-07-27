![Gem Version](https://img.shields.io/gem/v/oas_rails)
![GitHub License](https://img.shields.io/github/license/a-chacon/oas_rails)

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

## Usage

### Initializer File

You can easy create the initializer file with:

```
rails generate oas_rails:config
```

Then complete the created file with your data.

**Almost every description in a OAS file support simple markdown**

## Documenting Your Endpoints

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

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement". Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Roadmap and Ideas for Improvement

- Clean, document and structure the code
- Support documentation of authentication methods
- Define Global Tags/Configuration (e.g., common responses like 404 errors)
- Post-process the JSON and replace common objects with references to components
- Create a temporary file with the JSON in production mode to avoid rebuilding it on every request
- Create tags for popular gems used in APIs (e.g., a `@pagy` tag for common pagination parameters)
- Add basic authentication to OAS and UI for security reasons
- Implement ability to define OAS by namespaces (e.g., generate OAS for specific routes like `/api` or separate versions V1 and V2)

## License

The gem is available as open source under the terms of the [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html#license-text).
