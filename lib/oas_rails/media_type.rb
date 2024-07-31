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

      # Searches for examples in test files based on the provided class and test framework.
      #
      # This method handles different test frameworks to fetch examples for the given class.
      # Currently, it supports FactoryBot and fixtures.
      #
      # @param klass [Class] the class to search examples for.
      # @param utils [Module] a utility module that provides the `detect_test_framework` method. Defaults to `Utils`.
      # @return [Hash] a hash containing examples data or an empty hash if no examples are found.
      # @example Usage with FactoryBot
      #   search_for_examples_in_tests(klass: User)
      #
      # @example Usage with fixtures
      #   search_for_examples_in_tests(klass: Project)
      #
      # @example Usage with a custom utils module
      #   custom_utils = Module.new do
      #     def self.detect_test_framework
      #       :factory_bot
      #     end
      #   end
      #   search_for_examples_in_tests(klass: User, utils: custom_utils)
      def search_for_examples_in_tests(klass:, utils: Utils)
        case utils.detect_test_framework
        when :factory_bot
          {}
          # TODO: create examples with FactoryBot
        when :fixtures
          fixture_file = Rails.root.join('test', 'fixtures', "#{klass.to_s.pluralize.downcase}.yml")

          begin
            fixture_data = YAML.load_file(fixture_file).with_indifferent_access
          rescue Errno::ENOENT
            return {}
          end

          fixture_data.transform_values { |attributes| { value: { klass.to_s.downcase => attributes } } }
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
