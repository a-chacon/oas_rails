module OasRails
  module Spec
    class Responses
      include Specable
      attr_accessor :responses

      def initialize(responses:)
        @responses = responses
      end

      def to_spec
        spec = {}
        @responses.each do |key, value|
          spec[key] = value.to_spec
        end
        spec
      end

      class << self
        def from_tags(tags:)
          responses = tags.each_with_object({}) do |t, object|
            object[t.name.to_i] = Spec::Response.new(
              code: t.name.to_i,
              description: t.text,
              content: { "application/json": Spec::MediaType.new(schema: t.schema) }
            )
          end

          new(responses:)
        end
      end
    end
  end
end
