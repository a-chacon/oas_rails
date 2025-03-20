module OasRails
  module Spec
    class Components
      include Specable

      attr_accessor :schemas, :parameters, :security_schemes, :request_bodies, :responses, :headers, :examples, :links, :callbacks

      def initialize(specification)
        @specification = specification
        @schemas = {}
        @parameters = {}
        @security_schemes = OasRails.config.security_schemas
        @request_bodies = {}
        @responses = {}
        @headers = {}
        @examples = {}
        @links = {}
        @callbacks = {}

        # Initialize with an empty request body
        @request_bodies['empty'] = Spec::RequestBody.new(specification)
      end

      def oas_fields
        [:request_bodies, :examples, :responses, :schemas, :parameters, :security_schemes]
      end

      def add_response(response)
        key = response.hash_key
        @responses[key] = response unless @responses.key? key

        response_reference(key)
      end

      def add_parameter(parameter)
        key = parameter.hash_key
        @parameters[key] = parameter unless @parameters.key? key

        parameter_reference(key)
      end

      def add_request_body(request_body)
        key = request_body.hash_key
        @request_bodies[key] = request_body unless @request_bodies.key? key

        request_body_reference(key)
      end

      def add_schema(schema)
        key = nil
        if OasRails.config.use_model_names
          if schema[:type] == 'array'
            arr_schema = schema[:items]
            arr_key = arr_schema['title']
            key = "#{arr_key}List" unless arr_key.nil?
          else
            key = schema['title']
          end
        end

        key = Hashable.generate_hash(schema) if key.nil?

        @schemas[key] = schema if @schemas[key].nil?
        schema_reference(key)
      end

      def add_example(example)
        # If the example is nil or empty, return a blank reference
        return example_reference("empty_example") if example.nil? || (example.is_a?(Hash) && example.empty?)

        # Generate a consistent key for the example
        # If the example has a summary, use that to create a more readable key
        if example.is_a?(Hash) && example["summary"].is_a?(String) && !example["summary"].empty?
          base_key = example["summary"].downcase.gsub(/[^a-z0-9_]/, '_').gsub(/_+/, '_')
          key = base_key[0..63] # Limit key length
        else
          # Fall back to hash-based key if no suitable summary
          key = Hashable.generate_hash(example)
        end

        # Add an empty example if needed
        @examples["empty_example"] ||= { "summary" => "Empty Example", "value" => {} }

        # Only add the example if it doesn't exist yet
        @examples[key] = example if @examples[key].nil?

        # Get a reference to the example
        example_reference(key)
      end

      def create_reference(type, name)
        "#/components/#{type}/#{name}"
      end

      def schema_reference(name)
        Reference.new(create_reference('schemas', name))
      end

      def response_reference(name)
        Reference.new(create_reference('responses', name))
      end

      def parameter_reference(name)
        Reference.new(create_reference('parameters', name))
      end

      def example_reference(name)
        Reference.new(create_reference('examples', name))
      end

      def request_body_reference(name)
        Reference.new(create_reference('requestBodies', name))
      end
    end
  end
end
