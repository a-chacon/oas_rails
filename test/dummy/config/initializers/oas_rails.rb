# Configure two separate OAS Rails instances for testing mounting the engine multiple times
# This file provides two named configurations: :public and :internal
# Use `mount OasRails::Engine => '/path', default: { configuration: 'name' }` to mount each one.

# Public configuration - intended for external documentation
OasRails.configure(:public) do |config|
  # Basic Information about the API
  config.info.title = 'Dummy App Public API'
  config.info.version = '1.0.0'
  config.info.summary = 'Public-facing API for the Dummy app.'
  config.info.description = <<~HEREDOC
    This documentation exposes the public endpoints of the Dummy app. It is intended
    for external developers and clients who consume the public API surface.

    The documentation is automatically generated from routes and controller YARD tags
    and can be mounted at `/api/docs` in this dummy application.
  HEREDOC
  config.info.contact.name = 'Dummy Maintainer'
  config.info.contact.email = 'maintainer@example.com'
  config.info.contact.url = 'https://example.com'
  config.info.license.name = 'MIT'
  config.info.license.url = 'https://opensource.org/licenses/MIT'

  # Servers Information
  config.servers = [
    { url: 'http://localhost:3000', description: 'Local development' },
    { url: 'https://staging.example.com', description: 'Staging' }
  ]

  # Tags used to group endpoints (mirrors tags used in controllers)
  config.tags = [
    { name: 'Users', description: 'Operations to manage users (login, create, update, delete).' },
    { name: 'Projects', description: 'Manage projects belonging to users.' },
    { name: 'Typed', description: 'Small typed example endpoints used to test Sorbet integration.' },
    { name: 'Posts', description: 'Public blog-like posts endpoints.' },
    { name: 'Comments', description: 'Manage comments nested under posts.' }
  ]

  # Authentication defaults
  config.authenticate_all_routes_by_default = true
  config.security_schema = :bearer
  config.security_schemas = {
    bearer: {
      "type" => "http",
      "scheme" => "bearer",
      "bearerFormat" => "JWT",
      "description" => "JWT based authentication. Provide as `Authorization: Bearer <token>`"
    }
  }

  # Default error responses to be included where applicable
  config.set_default_responses = true
  config.possible_default_responses = [:not_found, :unauthorized, :forbidden, :internal_server_error, :unprocessable_entity]
  config.response_body_of_default = "Hash{ message: String }"
  config.response_body_of_unauthorized = "Hash{ message: String, error: Array<String> }"
  config.response_body_of_unprocessable_entity = "Hash{ errors: Array<String> }"

  config.ignored_actions = ["admin/reports"]
end

# Internal configuration - intended for internal docs / private APIs
OasRails.configure(:internal) do |config|
  config.info.title = 'Dummy App Internal API'
  config.info.version = '1.0.0-internal'
  config.info.summary = 'Internal API for developers and platform operators.'
  config.info.description = <<~HEREDOC
    Internal documentation contains private endpoints and operational APIs that
    should not be publicly exposed. This configuration is mounted at `/internal/api/docs`.
  HEREDOC
  config.info.contact.name = 'Platform Team'
  config.info.contact.email = 'platform@example.com'

  # Servers for internal environment
  config.servers = [
    { url: 'http://localhost:3000', description: 'Local development' },
    { url: 'https://internal.example.com', description: 'Internal staging' }
  ]

  # Internal tags (include admin and operational endpoints)
  config.tags = [
    { name: 'Admin', description: 'Administrative endpoints and operational reports.' },
    { name: 'Users', description: 'User management (internal view).' },
    { name: 'Projects', description: 'Project management (internal view).' },
    { name: 'Posts', description: 'Posts internal operations.' },
    { name: 'Comments', description: 'Comments internal operations.' }
  ]

  # Internal APIs often use API keys or other internal auth. Keep defaults permissive here.
  config.authenticate_all_routes_by_default = false
  config.security_schema = :api_key_header
  config.security_schemas = {
    api_key_header: {
      "type" => "apiKey",
      "in" => "header",
      "name" => "X-Internal-Api-Key",
      "description" => "Internal API key header"
    }
  }

  config.set_default_responses = true
  config.possible_default_responses = [:not_found, :unauthorized, :forbidden, :internal_server_error, :unprocessable_entity]
  config.response_body_of_default = "Hash{ message: String }"
  config.response_body_of_internal_server_error = "Hash{ error: String, traceback: String }"

  config.api_path = "/admin"
end
