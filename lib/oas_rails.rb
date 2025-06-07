require "yard"
require "method_source"
require "easy_talk"
require "oas_core"

OasCore.configure_yard!

module OasRails
  require "oas_rails/version"
  require "oas_rails/engine"

  autoload :Configuration, "oas_rails/configuration"
  autoload :Utils, "oas_rails/utils"
  autoload :JsonSchemaGenerator, "oas_rails/json_schema_generator"
  autoload :ActiveRecordExampleFinder, "oas_rails/active_record_example_finder"

  module Builders
    autoload :EsquemaBuilder, "oas_rails/builders/esquema_builder"
    autoload :OasRouteBuilder, "oas_rails/builders/oas_route_builder"
  end

  module Extractors
    autoload :RenderResponseExtractor, 'oas_rails/extractors/render_response_extractor'
    autoload :RouteExtractor, "oas_rails/extractors/route_extractor"
    autoload :OasRouteExtractor, "oas_rails/extractors/oas_route_extractor"
  end

  class << self
    def build
      OasCore.config = config

      host_routes = Extractors::RouteExtractor.host_routes
      oas = OasCore::Builders::SpecificationBuilder.new.with_oas_routes(host_routes).build

      oas.to_spec
    end

    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end
end
