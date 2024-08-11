module OasRails
  module Builders
    class PathItemBuilder
      def initialize(specification)
        @specification = specification
        @path_item = Spec::PathItem.new(specification)
      end

      def from_path(path, route_extractor: Extractors::RouteExtractor)
        route_extractor.host_routes_by_path(path).each do |oas_route|
          @path_item.add_operation(oas_route.verb.downcase, OperationBuilder.new(@specification).from_oas_route(oas_route).build)
        end

        self
      end

      def build
        @path_item
      end
    end
  end
end