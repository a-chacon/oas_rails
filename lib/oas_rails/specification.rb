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

    # Create the Base of the OAS hash.
    # @see https://spec.openapis.org/oas/latest.html#schema
    def base_spec
      {
        openapi: '3.1.0',
        info: OasRails.config.info.to_spec,
        servers: OasRails.config.servers.map(&:to_spec),
        paths:,
        components:,
        security:,
        tags: OasRails.config.tags.map(&:to_spec),
        externalDocs: {}
      }
    end

    # Create the Security Requirement Object.
    # @see https://spec.openapis.org/oas/latest.html#security-requirement-object
    def security
      return [] unless OasRails.config.authenticate_all_routes_by_default

      OasRails.config.security_schemas.map { |key, _| { key => [] } }
    end

    # Create the Paths Object For the Root of the OAS.
    # @see https://spec.openapis.org/oas/latest.html#paths-object
    def paths
      Paths.from_string_paths(string_paths: RouteExtractor.host_paths).to_spec
    end

    # Created the Components Object For the Root of the OAS.
    # @see https://spec.openapis.org/oas/latest.html#components-object
    def components
      {
        schemas: {}, parameters: {}, securitySchemes: security_schemas, requestBodies: {}, responses: {},
        headers: {}, examples: {}, links: {}, callbacks: {}
      }
    end

    # Create the Security Schemas Array inside components field of the OAS.
    # @see https://spec.openapis.org/oas/latest.html#security-scheme-object
    def security_schemas
      OasRails.config.security_schemas
    end
  end
end
