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

      def type_to_schema(type_string)
        if type_string.start_with?('Array<')
          inner_type = type_string[/Array<(.+)>$/, 1]
          {
            "type" => "array",
            "items" => type_to_schema(inner_type)
          }
        else
          { "type" => TYPE_MAPPING.fetch(type_string, 'string') }
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
    end
  end
end
