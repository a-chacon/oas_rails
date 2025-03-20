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

        # Extract clean description using our improved method
        description = extract_clean_description(oas_route.docstring)
        @operation.description = description

        @operation.tags = extract_tags(oas_route:)
        @operation.security = extract_security(oas_route:)
        @operation.parameters = ParametersBuilder.new(@specification).from_oas_route(oas_route).build

        # Build and debug the request body
        request_body_ref = RequestBodyBuilder.new(@specification).from_oas_route(oas_route).reference
        @operation.request_body = request_body_ref

        @operation.responses = ResponsesBuilder.new(@specification)
                                               .from_oas_route(oas_route)
                                               .add_autodiscovered_responses(oas_route)
                                               .add_default_responses(oas_route, !@operation.security.empty?).build

        self
      end

      def build
        @operation
      end

      private

      # Extracts clean description text from a docstring,
      # making sure to exclude any tag content or example JSON
      def extract_clean_description(docstring)
        # Extract the text content before any @ tags
        description = ""

        # Get the first description part, before any tags
        raw_text = docstring.all.to_s

        # Extract just the description lines, stopping at the first @ tag
        description_lines = []

        raw_text.each_line do |line|
          # Stop processing when we hit a line starting with @
          next if line.strip.start_with?('@')
          # Skip lines that look like part of a JSON example
          next if line.strip.match?(/^["'].*["']\s*:/)
          next if line.strip.match?(/^\{|\}$/)

          # Add this line to our description
          description_lines << line.strip
        end

        # Join the lines into a single string
        description = description_lines.join("\n")

        # Clean up any trailing JSON or curly braces
        description = description.sub(/\s*\{.*\}\s*$/m, '')

        # Return the cleaned description
        description.strip
      end
    end
  end
end
