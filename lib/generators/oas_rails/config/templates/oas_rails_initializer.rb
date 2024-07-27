# config/initializers/oas_rails.rb
OasRails.configure do |config|
  config.info.title = 'OasRails'
  config.info.summary = 'OasRails: Automatic Interactive API Documentation for Rails'
  config.info.description = <<~HEREDOC
    # Welcome to OasRails

    OasRails automatically generates interactive documentation for your Rails APIs using the OpenAPI Specification 3.1 (OAS 3.1) and displays it with a nice UI.

    ## Getting Started

    You've successfully mounted the OasRails engine. This default documentation is based on your routes and automatically gathered information.

    ## Enhancing Your Documentation

    To customize and enrich your API documentation:

    1. Generate an initializer file:

      ```
      rails generate oas_rails:config
      ```
    2. Edit the created `config/initializers/oas_rails.rb` file to override default settings and add project-specific information.

    3. Use Yard tags in your controller methods to provide detailed API endpoint descriptions.

    ## Features

    - Automatic OAS 3.1 document generation
    - [RapiDoc](https://github.com/rapi-doc/RapiDoc) integration for interactive exploration
    - Minimal setup required for basic documentation
    - Extensible through configuration and Yard tags

    Explore your API documentation and enjoy the power of OasRails!

    For more information and advanced usage, visit the [OasRails GitHub repository](https://github.com/a-chacon/oas_rails).


  HEREDOC
  config.info.contact.name = 'a-chacon'
  config.info.contact.email = 'andres.ch@proton.me'
  config.info.contact.url = 'https://a-chacon.com'
  config.servers = [{ url: 'http://localhost:3000', description: 'Local' }]
  config.tags = [{ name: "Users", description: "Manage the `amazing` Users table." }]

  # config.default_tags_from = :namespace # Could be: :namespace or :controller
  # config.request_body_automatically = true # Try to get request body for create and update methos based on the controller name.
  # config.autodiscover_responses = true # Looks for renders in your source code and try to generate the responses.
end
