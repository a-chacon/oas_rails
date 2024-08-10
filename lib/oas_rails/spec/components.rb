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
        key = Hashable.generate_hash(schema)
        @schemas[key] = schema if @schemas[key].nil?

        schema_reference(key)
      end

      def add_example(example)
        key = Hashable.generate_hash(example)
        @examples[key] = example if @examples[key].nil?

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
