require 'json'

module OasRails
  module Spec
    class Specification
      include Specable
      # Initializes a new Specification object.
      # Clears the cache if running in the development environment.
      def initialize
        clear_cache unless Rails.env.production?
      end

      # Clears the cache for MethodSource and RouteExtractor.
      #
      # @return [void]
      def clear_cache
        MethodSource.clear_cache
        Extractors::RouteExtractor.clear_cache
      end

      def oas_fields
        [:openapi, :info, :servers, :paths, :components, :security, :tags, :external_docs]
      end

      def openapi
        '3.1.0'
      end

      def info
        OasRails.config.info
      end

      def servers
        OasRails.config.servers
      end

      def tags
        OasRails.config.tags
      end

      def external_docs
        {}
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
        Spec::Paths.from_string_paths(string_paths: Extractors::RouteExtractor.host_paths)
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
end
