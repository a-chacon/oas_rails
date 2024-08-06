require "yard"
require "method_source"
require "esquema"

module OasRails
  require "oas_rails/version"
  require "oas_rails/engine"

  autoload :Configuration, "oas_rails/configuration"
  autoload :OasRoute, "oas_rails/oas_route"
  autoload :Utils, "oas_rails/utils"
  autoload :EsquemaBuilder, "oas_rails/esquema_builder"

  # This module contains all the clases that represent a part of the OAS file.
  module Spec
    autoload :Specable, "oas_rails/spec/specable"
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
  end

  module YARD
    autoload :OasYARDFactory, 'oas_rails/yard/oas_yard_factory'
  end

  module Extractors
    autoload :RenderResponseExtractor, 'oas_rails/extractors/render_response_extractor'
    autoload :RouteExtractor, "oas_rails/extractors/route_extractor"
  end

  class << self
    def build
      Spec::Specification.new.to_spec
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
      ::YARD::Tags::Library.default_factory = YARD::OasYARDFactory
      yard_tags = {
        'Request body' => [:request_body, :with_request_body],
        'Request body Example' => [:request_body_example, :with_request_body_example],
        'Parameter' => [:parameter, :with_parameter],
        'Response' => [:response, :with_response],
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
