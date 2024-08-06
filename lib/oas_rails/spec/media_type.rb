module OasRails
  module Spec
    class MediaType
      include Specable
      attr_accessor :schema, :example, :examples, :encoding

      # Initializes a new MediaType object.
      #
      # @param schema [Hash] the schema of the media type.
      # @param kwargs [Hash] additional keyword arguments.
      def initialize(schema:, **kwargs)
        @schema = schema
        @example = kwargs[:example] || {}
        @examples = kwargs[:examples] || {}
      end

      def oas_fields
        [:schema, :example, :examples, :encoding]
      end

      class << self
        @context = :incoming
        # Creates a new MediaType object from a model class.
        #
        # @param klass [Class] the ActiveRecord model class.
        # @param examples [Hash] the examples hash.
        # @return [MediaType, nil] the created MediaType object or nil if the class is not an ActiveRecord model.
        def from_model_class(klass:, context: :incoming, examples: {})
          @context = context
          return unless klass.ancestors.include? ActiveRecord::Base

          model_schema = EsquemaBuilder.send("build_#{@context}_schema", klass:)
          model_schema["required"] = []
          schema = { type: "object", properties: { klass.to_s.downcase => model_schema } }
          examples.merge!(search_for_examples_in_tests(klass:))
          new(media_type: "", schema:, examples:)
        end

        # Searches for examples in test files based on the provided class and test framework.
        #
        # @param klass [Class] the class to search examples for.
        # @param utils [Module] a utility module that provides the `detect_test_framework` method. Defaults to `Utils`.
        # @return [Hash] a hash containing examples data or an empty hash if no examples are found.
        def search_for_examples_in_tests(klass:, context: :incoming, utils: Utils)
          @context = context
          case utils.detect_test_framework
          when :factory_bot
            fetch_factory_bot_examples(klass:)
          when :fixtures
            fetch_fixture_examples(klass:)
          else
            {}
          end
        end

        # Transforms tags into examples.
        #
        # @param tags [Array] the array of tags.
        # @return [Hash] the transformed examples hash.
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

        private

        # Fetches examples from FactoryBot for the provided class.
        #
        # @param klass [Class] the class to fetch examples for.
        # @return [Hash] a hash containing examples data or an empty hash if no examples are found.
        def fetch_factory_bot_examples(klass:)
          klass_sym = klass.to_s.downcase.to_sym
          begin
            FactoryBot.build_stubbed_list(klass_sym, 3).each_with_index.to_h do |obj, index|
              ["#{klass_sym}#{index + 1}", { value: { klass_sym => clean_example_object(obj: obj.as_json) } }]
            end
          rescue KeyError
            {}
          end
        end

        # Fetches examples from fixtures for the provided class.
        #
        # @param klass [Class] the class to fetch examples for.
        # @return [Hash] a hash containing examples data or an empty hash if no examples are found.
        def fetch_fixture_examples(klass:)
          fixture_file = Rails.root.join('test', 'fixtures', "#{klass.to_s.pluralize.downcase}.yml")
          begin
            fixture_data = YAML.load_file(fixture_file).with_indifferent_access
          rescue Errno::ENOENT
            return {}
          end
          fixture_data.transform_values { |attributes| { value: { klass.to_s.downcase => clean_example_object(obj: attributes) } } }
        end

        def clean_example_object(obj:)
          obj.reject { |key, _| OasRails.config.send("excluded_columns_#{@context}").include?(key.to_sym) }
        end
      end
    end
  end
end
