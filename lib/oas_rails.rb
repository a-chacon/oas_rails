require "yard"
require "method_source"
require "esquema"

module OasRails
  require "oas_rails/version"
  require "oas_rails/engine"

  autoload :OasBase, "oas_rails/oas_base"
  autoload :Configuration, "oas_rails/configuration"
  autoload :Specification, "oas_rails/specification"
  autoload :RouteExtractor, "oas_rails/route_extractor"
  autoload :OasRoute, "oas_rails/oas_route"
  autoload :Operation, "oas_rails/operation"
  autoload :Info, "oas_rails/info"
  autoload :Contact, "oas_rails/contact"
  autoload :Paths, "oas_rails/paths"
  autoload :PathItem, "oas_rails/path_item"
  autoload :Parameter, "oas_rails/parameter"
  autoload :Tag, "oas_rails/tag"
  autoload :License, "oas_rails/license"
  autoload :Server, "oas_rails/server"
  autoload :RequestBody, "oas_rails/request_body"
  autoload :MediaType, "oas_rails/media_type"
  autoload :Response, "oas_rails/response"
  autoload :Responses, "oas_rails/responses"

  module Yard
    autoload :OasYardFactory, 'oas_rails/yard/oas_yard_factory'
  end

  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def configure_yard!
      ::YARD::Tags::Library.default_factory = Yard::OasYardFactory
      yard_tags = {
        'Request body' => [:request_body, :with_request_body],
        'Request body Example' => [:request_body_example, :with_request_body_example],
        'Parameter' => [:parameter, :with_parameter],
        'Response' => [:response, :with_response],
        'Endpoint Tags' => [:tags],
        'Summary' => [:summary],
        'No Auth' => [:no_auth],
        'Auth methods' => [:auth, :with_types]
      }
      yard_tags.each do |tag_name, (method_name, handler)|
        ::YARD::Tags::Library.define_tag(tag_name, method_name, handler)
      end
    end

    def configure_esquema!
      Esquema.configure do |config|
        config.exclude_associations = true
        config.exclude_foreign_keys = true
        config.excluded_columns = %i[id created_at updated_at deleted_at]
      end
    end

    def detect_test_framework
      if defined?(FactoryBot)
        :factory_bot
      elsif ActiveRecord::Base.connection.table_exists?('ar_internal_metadata')
        :fixtures
      else
        :unknown
      end
    end

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
