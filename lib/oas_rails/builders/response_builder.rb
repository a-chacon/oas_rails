module OasRails
  module Builders
    class ResponseBuilder
      def initialize(specification)
        @specification = specification
        @response = Spec::Response.new(specification)
      end

      def with_description(description)
        @response.description = description

        self
      end

      def with_content(content)
        @response.content = content

        self
      end

      def with_code(code)
        @response.code = code

        self
      end

      def from_tag(tag)
        @response.code = tag.name.to_i
        @response.description = tag.text
        @response.content = ContentBuilder.new(@specification, :outgoing).with_schema(tag.schema).build

        self
      end

      def build
        @response
      end
    end
  end
end
