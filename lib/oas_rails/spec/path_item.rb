module OasRails
  module Spec
    class PathItem
      include Specable
      attr_reader :path, :operations, :parameters

      def initialize(operations:, parameters:)
        @operations = operations
        @parameters = parameters
      end

      def self.from_oas_routes(oas_routes:)
        operations = oas_routes.each_with_object({}) do |oas_route, object|
          object[oas_route.verb.downcase] = Spec::Operation.from_oas_route(oas_route:)
        end

        new(operations:, parameters: [])
      end

      def to_spec
        spec = {}
        @operations.each do |key, value|
          spec[key] = value.to_spec
        end
        spec
      end
    end
  end
end
