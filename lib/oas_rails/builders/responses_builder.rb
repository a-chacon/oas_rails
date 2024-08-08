module OasRails
  module Builders
    class ResponsesBuilder
      def initialize(specification)
        @specification = specification
        @responses = Spec::Responses.new(specification)
      end

      def from_oas_route(oas_route)
        oas_route.docstring.tags(:response).each do |tag|
          @responses.add_response(ResponseBuilder.new(@specification).from_tag(tag).build)
        end

        self
      end

      def add_autodiscovered_responses(oas_route)
        return unless OasRails.config.autodiscover_responses

        new_responses = Extractors::RenderResponseExtractor.extract_responses_from_source(@specification, source: oas_route.source_string)

        new_responses.each do |new_response|
          @responses.add_response(new_response) if @responses.responses[new_response.code].blank?
        end

        self
      end

      def build
        @responses
      end
    end
  end
end
