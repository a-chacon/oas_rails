# Configuration

To configure OasRails, **you MUST create an initializer file** including all your settings. The first step is to create your initializer file, which you can easily do with:

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

- `config.include_mode`: Determines the mode for including operations. The default value is `all`, which means it will include all route operations under the `api_path`, whether documented or not. Other possible values:
  - `:with_tags`: Includes in your OAS only the operations with at least one tag. Example:

    Not included:

    ```ruby
    def update
    end
    ```

    Included:

    ```ruby
    # @summary Return all Books
    def index
    end
    ```

  - `:explicit`: Includes in your OAS only the operations tagged with `@oas_include`. Example:

    Not included:

    ```ruby
    def update
    end
    ```

    Included:

    ```ruby
    # @oas_include
    def index
    end
    ```

- `config.api_path`: Sets the API path if your API is under a different namespace than the root. This is important to configure if you have the `include_mode` set to `all` because it will include all routes of your app in the final OAS. For example, if your app has additional routes and your API is under the namespace `/api`, set this configuration as follows:

  ```ruby
  config.api_path = "/api"
  ```

- `config.ignored_actions`: Defines an array of controller or controller#action pairs. You do not need to prepend the `api_path`. This is useful when you want to include all routes except a few specific actions or when an external engine (e.g., Devise) adds routes to your API.

- `config.default_tags_from`: Determines the source of default tags for operations. Can be set to `:namespace` or `:controller`. The first option means that if your endpoint is in the route `/users/:id`, it will be tagged with `Users`. If set to `controller`, the tag will be `UsersController`.

- `config.autodiscover_request_body`: Automatically detects request bodies for create/update methods. Default is `true`.
- `config.autodiscover_responses`: Automatically detects responses from controller renders. Default is `true`.
- `config.http_verbs`: Defaults to `[:get, :post, :put, :patch, :delete]`
- `config.use_model_names`: Use model names when possible, defaults to `false`

### Authentication Settings

- `config.authenticate_all_routes_by_default`: Determines whether to authenticate all routes by default. Default is `true`.

- `config.security_schema`: The default security schema used for authentication. Choose from the following predefined options:
  - `:api_key_cookie`: API key passed via HTTP cookie.
  - `:api_key_header`: API key passed via HTTP header.
  - `:api_key_query`: API key passed via URL query parameter.
  - `:basic`: HTTP Basic Authentication.
  - `:bearer`: Bearer token (generic).
  - `:bearer_jwt`: Bearer token formatted as a JWT (JSON Web Token).
  - `:mutual_tls`: Mutual TLS authentication (mTLS).

- `config.security_schemas`: Custom security schemas. Follow the [OpenAPI Specification](https://spec.openapis.org/oas/latest.html#security-scheme-object) for defining these schemas.

### Default Errors

- `config.set_default_responses`: Determines whether to add default errors responses to endpoint. Default is `true`.

- `config.possible_default_responses`: Array with possible default errors.(Some will be added depending on the endpoint, example: not_found only works with show/update/delete). Default: [:not_found, :unauthorized, :forbidden]. It should be HTTP status code symbols from the list: `[:not_found, :unauthorized, :forbidden, :internal_server_error, :unprocessable_entity]`

- `config.response_body_of_default`: body for use in default responses. It must be a String hash like the used in request body tags. Default: "{ message: String }"

### Project License

- `config.info.license.name`: The title name of your project's license. Default: GPL 3.0

- `config.info.license.url`: The URL to the full license text. Default: <https://www.gnu.org/licenses/gpl-3.0.html#license-text>
