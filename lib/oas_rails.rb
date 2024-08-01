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

  autoload :Utils, "oas_rails/utils"

  module YARD
    autoload :OasYARDFactory, 'oas_rails/yard/oas_yard_factory'
  end

  class << self
    # Configurations for make the OasRails engine Work.
    def configure
      OasRails.configure_esquema!
      OasRails.configure_yard!
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def configure_yard!
      ::YARD::Tags::Library.default_factory = YARD::OasYARDFactory
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
  end
end
