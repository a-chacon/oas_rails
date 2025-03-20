module OasRails
  module Spec
    class MediaType
      include Specable

      attr_accessor :schema, :example, :examples, :encoding

      @context = :incoming
      @factory_examples = {}

      # Initializes a new MediaType object.
      #
      # @param schema [Hash] the schema of the media type.
      # @param kwargs [Hash] additional keyword arguments.
      def initialize(specification)
        @specification = specification
        @schema = {}
        @example =  {}
        @examples = {}
      end

      def oas_fields
        [:schema, :example, :examples, :encoding]
      end

      class << self
        # Searches for examples in test files based on the provided class and test framework.
        #
        # @param klass [Class] the class to search examples for.
        # @param utils [Module] a utility module that provides the `detect_test_framework` method. Defaults to `Utils`.
        # @return [Hash] a hash containing examples data or an empty hash if no examples are found.
        def search_for_examples_in_tests(klass, context: :incoming, utils: Utils)
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

        private

        # Fetches examples from FactoryBot for the provided class.
        #
        # @param klass [Class] the class to fetch examples for.
        # @return [Hash] a hash containing examples data or an empty hash if no examples are found.
        def fetch_factory_bot_examples(klass:)
          klass_sym = Utils.class_to_symbol(klass)

          begin
            @factory_examples[klass_sym] = FactoryBot.build_stubbed_list(klass_sym, 1) if @factory_examples[klass_sym].nil?

            @factory_examples[klass_sym].each_with_index.to_h do |obj, index|
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
            erb_result = ERB.new(File.read(fixture_file)).result
            fixture_data = YAML.safe_load(
              erb_result,
              permitted_classes: [Symbol, ActiveSupport::HashWithIndifferentAccess]
            ).with_indifferent_access
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
