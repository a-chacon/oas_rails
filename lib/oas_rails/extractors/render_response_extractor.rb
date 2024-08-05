module OasRails
  module Extractors
    # Extracts and processes render responses from a given source.
    module RenderResponseExtractor
      class << self
        # Extracts responses from the provided source string.
        #
        # @param source [String] The source string containing render calls.
        # @return [Array<Response>] An array of Response objects extracted from the source.
        def extract_responses_from_source(source:)
          render_calls = extract_render_calls(source)

          return [Spec::Response.new(code: 204, description: "No Content", content: {})] if render_calls.empty?

          render_calls.map { |render_content, status| process_render_content(render_content.strip, status) }
        end

        private

        # Extracts render calls from the source string.
        #
        # @param source [String] The source string containing render calls.
        # @return [Array<Array<String, String>>] An array of arrays, each containing render content and status.
        def extract_render_calls(source)
          source.scan(/render json: ((?:\{.*?\}|\S+))(?:, status: :(\w+))?(?:,.*?)?$/m)
        end

        # Processes the render content and status to build a Response object.
        #
        # @param content [String] The content extracted from the render call.
        # @param status [String] The status code associated with the render call.
        # @return [Response] A Response object based on the processed content and status.
        def process_render_content(content, status)
          schema, examples = build_schema_and_examples(content)
          status_int = status_to_integer(status)
          Spec::Response.new(
            code: status_int,
            description: status_code_to_text(status_int),
            content: { "application/json": Spec::MediaType.new(schema:, examples:) }
          )
        end

        # Builds schema and examples based on the content type.
        #
        # @param content [String] The content extracted from the render call.
        # @return [Array<Hash, Hash>] An array where the first element is the schema and the second is the examples.
        def build_schema_and_examples(content)
          if content.start_with?('{')
            [Utils.hash_to_json_schema(parse_hash_structure(content)), {}]
          else
            process_non_hash_content(content)
          end
        rescue StandardError => e
          Rails.logger.debug("Error building schema: #{e.message}")
          [{}]
        end

        # Processes non-hash content (e.g., model or method calls) to build schema and examples.
        #
        # @param content [String] The content extracted from the render call.
        # @return [Array<Hash, Hash>] An array where the first element is the schema and the second is the examples.
        def process_non_hash_content(content)
          maybe_a_model, errors = content.gsub('@', "").split(".")
          klass = maybe_a_model.singularize.camelize(:upper).constantize

          if klass.ancestors.include?(ActiveRecord::Base)
            schema = EsquemaBuilder.build_outgoing_schema(klass:)
            if test_singularity(maybe_a_model)
              build_singular_model_schema_and_examples(maybe_a_model, errors, klass, schema)
            else
              build_array_model_schema_and_examples(maybe_a_model, klass, schema)
            end
          else
            [{}]
          end
        end

        # Builds schema and examples for singular models.
        #
        # @param maybe_a_model [String] The model name or variable.
        # @param errors [String, nil] Errors related to the model.
        # @param klass [Class] The class associated with the model.
        # @param schema [Hash] The schema for the model.
        # @return [Array<Hash, Hash>] An array where the first element is the schema and the second is the examples.
        def build_singular_model_schema_and_examples(_maybe_a_model, errors, klass, schema)
          if errors.nil?
            [schema, MediaType.search_for_examples_in_tests(klass:, context: :outgoing)]
          else
            [
              {
                type: "object",
                properties: {
                  success: { type: "boolean" },
                  errors: {
                    type: "object",
                    additionalProperties: {
                      type: "array",
                      items: { type: "string" }
                    }
                  }
                }
              },
              {}
            ]
          end
        end

        # Builds schema and examples for array models.
        #
        # @param maybe_a_model [String] The model name or variable.
        # @param klass [Class] The class associated with the model.
        # @param schema [Hash] The schema for the model.
        # @return [Array<Hash, Hash>] An array where the first element is the schema and the second is the examples.
        def build_array_model_schema_and_examples(maybe_a_model, klass, schema)
          examples = { maybe_a_model => { value: MediaType.search_for_examples_in_tests(klass:, context: :outgoing).values.map { |p| p.dig(:value, maybe_a_model.singularize.to_sym) } } }
          [{ type: "array", items: schema }, examples]
        end

        # Determines if a string represents a singular model.
        #
        # @param str [String] The string to test.
        # @return [Boolean] True if the string is a singular model, false otherwise.
        def test_singularity(str)
          str.pluralize != str && str.singularize == str
        end

        # Parses a hash literal to determine its structure.
        #
        # @param hash_literal [String] The hash literal string.
        # @return [Hash<Symbol, String>] A hash representing the structure of the input.
        def parse_hash_structure(hash_literal)
          structure = {}

          hash_literal.scan(/(\w+):\s*(\S+)/) do |key, value|
            structure[key.to_sym] = case value
                                    when 'true', 'false'
                                      'Boolean'
                                    when /^\d+$/
                                      'Number'
                                    else
                                      'Object'
                                    end
          end

          structure
        end

        # Converts a status symbol or string to an integer.
        #
        # @param status [String, Symbol, nil] The status to convert.
        # @return [Integer] The status code as an integer.
        def status_to_integer(status)
          return 200 if status.nil?

          if status.to_s =~ /^\d+$/
            status.to_i
          else
            status = "unprocessable_content" if status == "unprocessable_entity"
            Rack::Utils::SYMBOL_TO_STATUS_CODE[status.to_sym]
          end
        end

        # Converts a status code to its corresponding text description.
        #
        # @param status_code [Integer] The status code.
        # @return [String] The text description of the status code.
        def status_code_to_text(status_code)
          Rack::Utils::HTTP_STATUS_CODES[status_code] || "Unknown Status Code"
        end
      end
    end
  end
end
