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
    # NOTE: This lambda is called back by OasCore during build and has no way to receive
    # a named config as a parameter. It falls back to OasRails.config(:default).
    # This is a known limitation: excluded_columns in EsquemaBuilder will always use
    # the default config when invoked from this re-entry point.
    OasCore::JsonSchemaGenerator.register_type_parser(
      ->(t) { Utils.active_record_class?(t) },
      ->(type, _required) { Builders::EsquemaBuilder.build_outgoing_schema(klass: type.constantize) }
    )

    def build(config: OasRails.config)
      clear_cache(config:)
      OasCore.config = config

      host_routes = config.route_extractor.host_routes(config:)
      oas_source = config.source_oas_path ? read_source_oas_file(config:) : {}

      OasCore.build(host_routes, oas_source: oas_source)
    end

    def configure(name = :default)
      cfg = Configuration.new
      yield cfg
      cfg.instance_variable_set(:@name, name)
      @configs ||= {}
      @configs[name] = cfg
    end

    def config(name = :default)
      @configs ||= {}
      @configs[name] ||= Configuration.new
    end

    private

    def clear_cache(config:)
      return if Rails.env.production?

      MethodSource.clear_cache
      OasRails::Extractors::RouteExtractor.clear_cache(config:)
    end

    def read_source_oas_file(config:)
      file_path = Rails.root.join(config.source_oas_path)
      JSON.parse(File.read(file_path), symbolize_names: true)
    rescue Errno::ENOENT => e
      raise "Failed to read source OAS file at #{file_path}: #{e.message}"
    rescue JSON::ParserError => e
      raise "Failed to parse source OAS file at #{file_path}: #{e.message}"
    end
  end
end
