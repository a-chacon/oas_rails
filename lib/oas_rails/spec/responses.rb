module OasRails
  module Spec
    class Responses
      include Specable
      attr_accessor :responses

      def initialize(specification)
        @specification = specification
        @responses = {}
      end

      def add_response(response)
        @responses[response.code] = @specification.components.add_response(response)
      end

      def to_spec
        spec = {}
        @responses.each do |key, value|
          spec[key] = value.to_spec
        end
        spec
      end
    end
  end
end
