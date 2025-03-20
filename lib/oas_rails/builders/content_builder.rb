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
        # Don't process if there are no tags
        return self if tags.nil? || tags.empty?

        # Create the examples hash based on the tags
        example_hash = tags.each_with_object({}) do |example, result|
          # Generate a key from the example text
          key = example.text.downcase.gsub(' ', '_')

          # Create the example object with summary and value
          value = {
            "summary" => example.text,
            "value" => example.content
          }

          # Add to the result hash
          result[key] = value
        end

        # If we have examples, add them to the media type
        unless example_hash.empty?
          # Add the examples to the components
          examples_refs = example_hash.transform_values do |example|
            @specification.components.add_example(example)
          end

          # Merge with any existing examples
          @media_type.examples = @media_type.examples.merge(examples_refs)
        end

        self
      end

      def from_model_class(klass)
        return self unless klass.ancestors.map(&:to_s).include? 'ActiveRecord::Base'

        model_schema = Builders::EsquemaBuilder.send("build_#{@context}_schema", klass:)
        model_schema["required"] = []
        schema = { type: "object", properties: { klass.to_s.downcase => model_schema } }
        examples = Spec::MediaType.search_for_examples_in_tests(klass, context: @context)
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
