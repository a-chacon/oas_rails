require 'json'

module OasRails
  class Specification
    def initialize
      OasRails.configure_esquema!
      OasRails.configure_yard!
      @specification = base_spec
    end

    def to_json(*_args)
      @specification.to_json
    rescue StandardError => e
      Rails.logger.error("Error Generating OAS: #{e.message}")
      {}
    end

    def base_spec
      {
        openapi: '3.1.0',
        info: OasRails.config.info.to_spec,
        servers: OasRails.config.servers.map(&:to_spec),
        paths: paths_spec,
        components: components_spec,
        security: [],
        tags: OasRails.config.tags.map(&:to_spec),
        externalDocs: {}
      }
    end

    def paths_spec
      Paths.from_string_paths(string_paths: RouteExtractor.host_paths).to_spec
    end

    def components_spec
      {
        schemas: {}, parameters: {}, securitySchemas: {}, requestBodies: {}, responses: {},
        headers: {}, examples: {}, links: {}, callbacks: {}
      }
    end
  end
end
