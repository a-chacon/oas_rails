module OasRails
  module Utils
    TYPE_MAPPING = {
      'String' => 'string',
      'Integer' => 'number',
      'Float' => 'number',
      'TrueClass' => 'boolean',
      'FalseClass' => 'boolean',
      'Boolean' => 'boolean',
      'NilClass' => 'null',
      'Hash' => 'object',
      'Object' => 'object',
      'DateTime' => 'string'
    }.freeze

    HTTP_STATUS_DEFINITIONS = {
      200 => "The request has succeeded.",
      201 => "The request has been fulfilled and resulted in a new resource being created.",
      404 => "The requested resource could not be found.",
      401 => "You are not authorized to access this resource. You need to authenticate yourself first.",
      403 => "You are not allowed to access this resource. You do not have the necessary permissions.",
      500 => "An unexpected error occurred on the server. The server was unable to process the request.",
      422 => "The server could not process the request due to semantic errors. Please check your input and try again."
    }.freeze

    class << self
      # Method for detect test framework of the Rails App
      # It is used for generate examples in operations
      def detect_test_framework
        if defined?(FactoryBot)
          :factory_bot
        elsif ActiveRecord::Base.connection.table_exists?('ar_internal_metadata')
          :fixtures
        else
          :unknown
        end
      end

      def hash_to_json_schema(hash)
        {
          type: 'object',
          properties: hash_to_properties(hash),
          required: []
        }
      end

      def hash_to_properties(hash)
        hash.transform_values do |value|
          if value.is_a?(Hash)
            hash_to_json_schema(value)
          elsif value.is_a?(Class)
            { type: ruby_type_to_json_type(value.name) }
          else
            { type: ruby_type_to_json_type(value.class.name) }
          end
        end
      end

      def ruby_type_to_json_type(ruby_type)
        TYPE_MAPPING.fetch(ruby_type, 'string')
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
          Rack::Utils.status_code(status.to_sym)
        end
      end

      # Converts a status code to its corresponding text description.
      #
      # @param status_code [Integer] The status code.
      # @return [String] The text description of the status code.
      def get_definition(status_code)
        HTTP_STATUS_DEFINITIONS[status_code] || "Definition not found for status code #{status_code}"
      end

      def class_to_symbol(klass)
        klass.name.underscore.to_sym
      end

      def find_model_from_route(path)
        parts = path.split('/')
        model_name = parts.last.singularize.camelize

        namespace_combinations = (0..parts.size).map do |i|
          parts.first(i).map(&:camelize).join('::')
        end

        namespace_combinations.reverse.each do |namespace|
          full_class_name = [namespace, model_name].reject(&:empty?).join('::')
          begin
            return full_class_name.constantize
          rescue NameError
            next
          end
        end

        nil # Return nil if no matching constant is found
      end

      # Checks if a given text refers to an ActiveRecord class.
      # @param text [String] The text to check.
      # @return [Boolean] True if the text refers to an ActiveRecord class, false otherwise.
      def active_record_class?(klass_or_string)
        klass = klass_or_string.is_a?(Class) ? klass_or_string : klass_or_string.constantize
        klass.ancestors.map(&:to_s).include? 'ActiveRecord::Base'
      rescue StandardError
        false
      end
    end
  end
end
