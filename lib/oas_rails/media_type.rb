module OasRails
  class MediaType < OasBase
    attr_accessor :schema, :example, :examples, :encoding

    def initialize(schema:, **kwargs)
      super()
      @schema = schema
      @example = kwargs[:example] || {}
      @examples = kwargs[:examples] || []
    end

    class << self
      def from_model_class(klass:, examples: {})
        return unless klass.ancestors.include? ActiveRecord::Base

        model_schema = Esquema::Builder.new(klass).build_schema.as_json
        model_schema["required"] = []
        schema = { type: "object", properties: { klass.to_s.downcase => model_schema } }
        examples.merge!(search_for_examples_in_tests(klass:))
        new(media_type: "", schema:, examples:)
      end

      def search_for_examples_in_tests(klass:)
        case Utils.detect_test_framework
        when :factory_bot
          {}
          # TODO: create examples with FactoryBot
        when :fixtures
          # Handle fixtures scenario
          fixture_file = Rails.root.join('test', 'fixtures', "#{klass.to_s.pluralize.downcase}.yml")
          fixture_data = YAML.load_file(fixture_file).with_indifferent_access

          users_hash = {}

          # Convert the fixture data to a hash
          fixture_data.each do |name, attributes|
            users_hash[name] = { value: { klass.to_s.downcase => attributes } }
          end
          users_hash
        else
          {}
        end
      end

      def tags_to_examples(tags:)
        tags.each_with_object({}).with_index(1) do |(example, result), _index|
          key = example.text.downcase.gsub(' ', '_')
          value = {
            "summary" => example.text,
            "value" => example.content
          }
          result[key] = value
        end
      end
    end
  end
end
