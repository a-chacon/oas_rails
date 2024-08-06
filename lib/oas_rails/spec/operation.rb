module OasRails
  module Spec
    class Operation
      include Specable

      attr_accessor :tags, :summary, :description, :operation_id, :parameters, :meth, :docstring, :request_body, :responses, :security

      def initialize(method:, summary:, operation_id:, **kwargs)
        @meth = method
        @summary = summary
        @operation_id = operation_id
        @tags = kwargs[:tags] || []
        @description = kwargs[:description] || @summary
        @parameters = kwargs[:parameters] || []
        @request_body = kwargs[:request_body] || {}
        @responses = kwargs[:responses] || {}
        @security = kwargs[:security] || []
      end

      def oas_fields
        [:tags, :summary, :description, :operation_id, :parameters, :request_body, :responses, :security]
      end

      class << self
        def from_oas_route(oas_route:)
          summary = extract_summary(oas_route:)
          operation_id = extract_operation_id(oas_route:)
          tags = extract_tags(oas_route:)
          description = oas_route.docstring
          parameters = extract_parameters(oas_route:)
          request_body = extract_request_body(oas_route:)
          responses = extract_responses(oas_route:)
          security = extract_security(oas_route:)
          new(method: oas_route.verb.downcase, summary:, operation_id:, tags:, description:, parameters:, request_body:, responses:, security:)
        end

        def extract_summary(oas_route:)
          oas_route.docstring.tags(:summary).first.try(:text) || generate_crud_name(oas_route.method, oas_route.controller.downcase) || "#{oas_route.verb} #{oas_route.path}"
        end

        def generate_crud_name(method, controller)
          controller_name = controller.to_s.underscore.humanize.downcase.pluralize

          case method.to_sym
          when :index
            "List #{controller_name}"
          when :show
            "View #{controller_name.singularize}"
          when :create
            "Create new #{controller_name.singularize}"
          when :update
            "Update #{controller_name.singularize}"
          when :destroy
            "Delete #{controller_name.singularize}"
          end
        end

        def extract_operation_id(oas_route:)
          "#{oas_route.method}#{oas_route.path.gsub('/', '_').gsub(/[{}]/, '')}"
        end

        # This method should check tags defined by yard, then extract tag from path namespace or controller name depending on configuration
        def extract_tags(oas_route:)
          tags = oas_route.docstring.tags(:tags).first
          if tags.nil?
            default_tags(oas_route:)
          else
            tags.text.split(",").map(&:strip).map(&:titleize)
          end
        end

        def default_tags(oas_route:)
          tags = []
          if OasRails.config.default_tags_from == "namespace"
            tag = oas_route.path.split('/').reject(&:empty?).first.try(:titleize)
            tags << tag unless tag.nil?
          else
            tags << oas_route.controller.titleize
          end
          tags
        end

        def extract_parameters(oas_route:)
          parameters = []
          parameters.concat(parameters_from_tags(tags: oas_route.docstring.tags(:parameter)))
          oas_route.path_params.try(:map) do |p|
            parameters << Spec::Parameter.from_path(path: oas_route.path, param: p) unless parameters.any? { |param| param.name.to_s == p.to_s }
          end
          parameters
        end

        def parameters_from_tags(tags:)
          tags.map do |t|
            Spec::Parameter.new(name: t.name, location: t.location, required: t.required, schema: t.schema, description: t.text)
          end
        end

        def extract_request_body(oas_route:)
          tag_request_body = oas_route.docstring.tags(:request_body).first
          if tag_request_body.nil? && OasRails.config.autodiscover_request_body
            oas_route.detect_request_body if %w[create update].include? oas_route.method
          elsif !tag_request_body.nil?
            Spec::RequestBody.from_tags(tag: tag_request_body, examples_tags: oas_route.docstring.tags(:request_body_example))
          else
            {}
          end
        end

        def extract_responses(oas_route:)
          responses = Spec::Responses.from_tags(tags: oas_route.docstring.tags(:response))

          if OasRails.config.autodiscover_responses
            new_responses = Extractors::RenderResponseExtractor.extract_responses_from_source(source: oas_route.source_string)

            new_responses.each do |new_response|
              responses.responses[new_response.code] = new_response if responses.responses[new_response.code].blank?
            end
          end

          responses
        end

        def extract_security(oas_route:)
          return [] if oas_route.docstring.tags(:no_auth).any?

          if (methods = oas_route.docstring.tags(:auth).first)
            OasRails.config.security_schemas.keys.map { |key| { key => [] } }.select do |schema|
              methods.types.include?(schema.keys.first.to_s)
            end
          elsif OasRails.config.authenticate_all_routes_by_default
            OasRails.config.security_schemas.keys.map { |key| { key => [] } }
          else
            []
          end
        end

        def external_docs; end
      end
    end
  end
end
