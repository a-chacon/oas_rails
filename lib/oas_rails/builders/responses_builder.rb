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

        content = ContentBuilder.new(@specification, :outgoing).with_schema(JsonSchemaGenerator.process_string(OasRails.config.response_body_of_default)[:json_schema]).build
        common_errors = []
        common_errors.push(:unauthorized, :forbidden) if security

        case oas_route.method
        when "show", "update", "destroy"
          common_errors.push(:not_found)
        when "create", "index"
          # possible errors for this methods?
        end

        (OasRails.config.possible_default_responses & common_errors).each do |e|
          code = Utils.status_to_integer(e)
          response = ResponseBuilder.new(@specification).with_code(code).with_description(Utils.get_definition(code)).with_content(content).build

          @responses.add_response(response) if @responses.responses[response.code].blank?
        end

        self
      end

      def build
        @responses
      end
    end
  end
end
