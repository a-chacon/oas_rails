module OasRails
  module Spec
    class PathItem
      include Specable
      attr_reader :get, :post, :put, :patch, :delete

      def initialize(specification)
        @specification = specification
        @get = nil
        @post = nil
        @put = nil
        @patch = nil
        @delete = nil
      end

      def fill_from(path, route_extractor: Extractors::RouteExtractor)
        route_extractor.host_routes_by_path(path).each do |oas_route|
          add_operation(oas_route.verb.downcase, Spec::Operation.new(@specification).fill_from(oas_route))
        end

        self
      end

      def add_operation(http_method, operation)
        instance_variable_set("@#{http_method}", operation)
      end

      def oas_fields
        OasRails.config.http_verbs
      end
    end
  end
end
