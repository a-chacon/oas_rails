module OasRails
  module Spec
    class Info < Spec::Base
      attr_accessor :title, :summary, :description, :terms_of_service, :contact, :license, :version

      def initialize(**kwargs)
        super()
        @title = kwargs[:title] || default_title
        @summary = kwargs[:summary] || default_summary
        @description = kwargs[:description] || default_description
        @terms_of_service = kwargs[:terms_of_service] || ''
        @contact = Spec::Contact.new
        @license = Spec::License.new
        @version = kwargs[:version] || '0.0.1'
      end

      def default_title
        "OasRails #{VERSION}"
      end

      def default_summary
        "OasRails: Automatic Interactive API Documentation for Rails"
      end

      def default_description
        "# Welcome to OasRails

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

      "
      end
    end
  end
end
