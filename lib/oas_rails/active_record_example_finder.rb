module OasRails
  class ActiveRecordExampleFinder
    def initialize(context: :incoming, utils: Utils, factory_bot: FactoryBot, erb: ERB, yaml: YAML, file: File)
      @context = context
      @utils = utils
      @factory_bot = factory_bot
      @erb = erb
      @yaml = yaml
      @file = file
      @factory_examples = {}
    end

    def search(klass)
      case @utils.detect_test_framework
      when :factory_bot
        fetch_factory_bot_examples(klass: klass)
      when :fixtures
        fetch_fixture_examples(klass: klass)
      else
        {}
      end
    end

    # Fetches examples from FactoryBot for the provided class.
    #
    # @param klass [Class] the class to fetch examples for.
    # @return [Hash] a hash containing examples data or an empty hash if no examples are found.
    def fetch_factory_bot_examples(klass:)
      klass_sym = @utils.class_to_symbol(klass)

      begin
        @factory_examples[klass_sym] = @factory_bot.build_stubbed_list(klass_sym, 1) if @factory_examples[klass_sym].nil?

        @factory_examples[klass_sym].each_with_index.to_h do |obj, index|
          ["#{klass_sym}#{index + 1}", { value: { klass_sym => clean_example_object(obj: obj.as_json) } }]
        end.deep_symbolize_keys
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
        erb_result = @erb.new(@file.read(fixture_file)).result
        fixture_data = @yaml.safe_load(
          erb_result,
          aliases: true,
          permitted_classes: [Symbol, ActiveSupport::HashWithIndifferentAccess, Time]
        ).with_indifferent_access
      rescue Errno::ENOENT
        return {}
      end
      fixture_data.transform_values { |attributes| { value: { klass.to_s.downcase => clean_example_object(obj: attributes) } } }.deep_symbolize_keys
    end

    def clean_example_object(obj:)
      obj.reject { |key, _| OasRails.config.send("excluded_columns_#{@context}").include?(key.to_sym) }
    end
  end
end
