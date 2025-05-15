require 'json'

module OasRails
  module Spec
    class Specification
      include Specable
      attr_accessor :components, :info, :openapi, :servers, :tags, :external_docs, :paths, :route_extractor

      def initialize
        @components = Components.new(self)
        @info = OasRails.config.info
        @openapi = '3.1.0'
        @servers = OasRails.config.servers
        @tags = OasRails.config.tags
        @external_docs = {}
        @paths = Spec::Paths.new(self)
      end

      def oas_fields
        [:openapi, :info, :servers, :paths, :components, :security, :tags, :external_docs]
      end

      # Create the Security Requirement Object.
      # @see https://spec.openapis.org/oas/latest.html#security-requirement-object
      def security
        return [] unless OasRails.config.authenticate_all_routes_by_default

        OasRails.config.security_schemas.map { |key, _| { key => [] } }
      end
    end
  end
end
