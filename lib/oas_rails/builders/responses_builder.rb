module OasRails
  module Builders
    class ResponsesBuilder
      def initialize(specification)
        @specification = specification
        @responses = Spec::Responses.new(specification)
      end

      def from_oas_route(oas_route)
        oas_route.docstring.tags(:response).each do |tag|
          content = ContentBuilder.new(@specification, :outgoing).with_schema(tag.schema).with_examples_from_tags(oas_route.docstring.tags(:response_example).filter { |re| re.code == tag.name }).build
          response = ResponseBuilder.new(@specification).with_code(tag.name.to_i).with_description(tag.text).with_content(content).build

          @responses.add_response(response)
        end

        self
      end

      def add_autodiscovered_responses(oas_route)
        return self if !OasRails.config.autodiscover_responses || oas_route.docstring.tags(:response).any?

        new_responses = Extractors::RenderResponseExtractor.extract_responses_from_source(@specification, source: oas_route.source_string)

        new_responses.each do |new_response|
          @responses.add_response(new_response) if @responses.responses[new_response.code].blank?
        end

        self
      end

      def add_default_responses(oas_route, security)
        return self unless OasRails.config.set_default_responses

        common_errors = determine_common_errors(oas_route, security)
        add_responses_for_errors(common_errors)

        self
      end

      def build
        @responses
      end

      private

      def determine_common_errors(oas_route, security)
        common_errors = []
        common_errors.push(:unauthorized, :forbidden, :internal_server_error) if security

        case oas_route.method
        when "show", "destroy"
          common_errors.push(:not_found)
        when "create"
          common_errors.push(:unprocessable_entity)
        when "update"
          common_errors.push(:not_found, :unprocessable_entity)
        end

        OasRails.config.possible_default_responses & common_errors
      end

      def add_responses_for_errors(errors)
        errors.each do |error|
          response_body = resolve_response_body(error)
          content = ContentBuilder.new(@specification, :outgoing).with_schema(JsonSchemaGenerator.process_string(response_body)[:json_schema]).build
          code = Utils.status_to_integer(error)
          response = ResponseBuilder.new(@specification).with_code(code).with_description(Utils.get_definition(code)).with_content(content).build

          @responses.add_response(response) if @responses.responses[response.code].blank?
        end
      end

      def resolve_response_body(error)
        OasRails.config.public_send("response_body_of_#{error}")
      rescue StandardError
        OasRails.config.response_body_of_default
      end
    end
  end
end
