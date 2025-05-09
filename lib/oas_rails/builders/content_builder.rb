module OasRails
  module Builders
    class ContentBuilder
      def initialize(specification, context)
        @context = context || :incoming
        @specification = specification
        @media_type = Spec::MediaType.new(specification)
      end

      def with_schema(schema)
        @media_type.schema = @specification.components.add_schema(schema)

        self
      end

      def with_examples(examples)
        @media_type.examples = @specification.components.add_example(examples)

        self
      end

      def with_examples_from_tags(tags)
        @media_type.examples = @media_type.examples.merge(tags.each_with_object({}).with_index(1) do |(example, result), _index|
          key = example.text.downcase.gsub(' ', '_')
          value = {
            "summary" => example.text,
            "value" => example.content
          }
          result[key] = @specification.components.add_example(value)
        end)

        self
      end

      def from_model_class(klass)
        return self unless Utils.active_record_class?(klass)

        model_schema = Builders::EsquemaBuilder.send("build_#{@context}_schema", klass:)
        model_schema["required"] = []
        schema = { type: "object", properties: { klass.to_s.downcase => model_schema } }
        examples = ActiveRecordExampleFinder.new(context: @context).search(klass)
        @media_type.schema = @specification.components.add_schema(schema)
        @media_type.examples = @media_type.examples.merge(examples)

        self
      end

      def build
        {
          "application/json": @media_type
        }
      end
    end
  end
end
