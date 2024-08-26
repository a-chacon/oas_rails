require "yard"
require "method_source"
require "esquema"

module OasRails
  require "oas_rails/version"
  require "oas_rails/engine"

  autoload :Configuration, "oas_rails/configuration"
  autoload :OasRoute, "oas_rails/oas_route"
  autoload :Utils, "oas_rails/utils"
  autoload :JsonSchemaGenerator, "oas_rails/json_schema_generator"

  module Builders
    autoload :OperationBuilder, "oas_rails/builders/operation_builder"
    autoload :PathItemBuilder, "oas_rails/builders/path_item_builder"
    autoload :ResponseBuilder, "oas_rails/builders/response_builder"
    autoload :ResponsesBuilder, "oas_rails/builders/responses_builder"
    autoload :ContentBuilder, "oas_rails/builders/content_builder"
    autoload :ParametersBuilder, "oas_rails/builders/parameters_builder"
    autoload :ParameterBuilder, "oas_rails/builders/parameter_builder"
    autoload :RequestBodyBuilder, "oas_rails/builders/request_body_builder"
    autoload :EsquemaBuilder, "oas_rails/builders/esquema_builder"
  end

  # This module contains all the clases that represent a part of the OAS file.
  module Spec
    autoload :Hashable, "oas_rails/spec/hashable"
    autoload :Specable, "oas_rails/spec/specable"
    autoload :Components, "oas_rails/spec/components"
    autoload :Parameter, "oas_rails/spec/parameter"
    autoload :License, "oas_rails/spec/license"
    autoload :Response, "oas_rails/spec/response"
    autoload :PathItem, "oas_rails/spec/path_item"
    autoload :Operation, "oas_rails/spec/operation"
    autoload :RequestBody, "oas_rails/spec/request_body"
    autoload :Responses, "oas_rails/spec/responses"
    autoload :MediaType, "oas_rails/spec/media_type"
    autoload :Paths, "oas_rails/spec/paths"
    autoload :Contact, "oas_rails/spec/contact"
    autoload :Info, "oas_rails/spec/info"
    autoload :Server, "oas_rails/spec/server"
    autoload :Tag, "oas_rails/spec/tag"
    autoload :Specification, "oas_rails/spec/specification"
    autoload :Reference, "oas_rails/spec/reference"
  end

  module YARD
    autoload :RequestBodyTag, 'oas_rails/yard/request_body_tag'
    autoload :ExampleTag, 'oas_rails/yard/example_tag'
    autoload :RequestBodyExampleTag, 'oas_rails/yard/request_body_example_tag'
    autoload :ParameterTag, 'oas_rails/yard/parameter_tag'
    autoload :ResponseTag, 'oas_rails/yard/response_tag'
    autoload :ResponseExampleTag, 'oas_rails/yard/response_example_tag'
    autoload :OasRailsFactory, 'oas_rails/yard/oas_rails_factory'
  end

  module Extractors
    autoload :RenderResponseExtractor, 'oas_rails/extractors/render_response_extractor'
    autoload :RouteExtractor, "oas_rails/extractors/route_extractor"
    autoload :OasRouteExtractor, "oas_rails/extractors/oas_route_extractor"
  end

  class << self
    def build
      oas = Spec::Specification.new
      oas.build

      oas.to_spec
    end

    # Configurations for make the OasRails engine Work.
    def configure
      OasRails.configure_yard!
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def configure_yard!
      ::YARD::Tags::Library.default_factory = YARD::OasRailsFactory
      yard_tags = {
        'Request body' => [:request_body, :with_request_body],
        'Request body Example' => [:request_body_example, :with_request_body_example],
        'Parameter' => [:parameter, :with_parameter],
        'Response' => [:response, :with_response],
        'Response Example' => [:response_example, :with_response_example],
        'Endpoint Tags' => [:tags],
        'Summary' => [:summary],
        'No Auth' => [:no_auth],
        'Auth methods' => [:auth, :with_types]
      }
      yard_tags.each do |tag_name, (method_name, handler)|
        ::YARD::Tags::Library.define_tag(tag_name, method_name, handler)
      end
    end
  end
end
