module OasRails
  module Builders
    class OperationBuilder
      include Extractors::OasRouteExtractor

      def initialize(specification)
        @specification = specification
        @operation = Spec::Operation.new(specification)
      end

      def from_oas_route(oas_route)
        @operation.summary = extract_summary(oas_route:)
        @operation.operation_id = extract_operation_id(oas_route:)
        @operation.description = oas_route.docstring
        @operation.tags = extract_tags(oas_route:)
        @operation.security = extract_security(oas_route:)
        @operation.parameters = ParametersBuilder.new(@specification).from_oas_route(oas_route).build
        @operation.request_body = RequestBodyBuilder.new(@specification).from_oas_route(oas_route).reference
        @operation.responses = ResponsesBuilder.new(@specification).from_oas_route(oas_route).add_autodiscovered_responses(oas_route).build

        self
      end

      def build
        @operation
      end
    end
  end
end
