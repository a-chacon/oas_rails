module OasRails
  module Builders
    class RequestBodyBuilder
      def initialize(specification)
        @specification = specification
        @request_body = Spec::RequestBody.new(specification)
      end

      def from_oas_route(oas_route)
        tag_request_body = oas_route.tags(:request_body).first
        if tag_request_body.nil? && OasRails.config.autodiscover_request_body
          detect_request_body(oas_route) if %w[create update].include? oas_route.method
        elsif !tag_request_body.nil?
          from_tags(tag: tag_request_body, examples_tags: oas_route.tags(:request_body_example))
        end

        self
      end

      def from_tags(tag:, examples_tags: [])
        if Utils.active_record_class?(tag.klass)
          from_model_class(klass: tag.klass, description: tag.text, required: tag.required, content_type: tag.content_type, examples_tags:)
        else
          @request_body.description = tag.text
          @request_body.content = ContentBuilder.new(@specification, :incoming).with_schema(tag.schema).with_examples_from_tags(examples_tags).with_content_type(tag.content_type).build
          @request_body.required = tag.required
        end

        self
      end

      def from_model_class(klass:, **kwargs)
        @request_body.description = kwargs[:description] || klass.to_s
        @request_body.content = ContentBuilder.new(@specification, :incoming).from_model_class(klass).with_examples_from_tags(kwargs[:examples_tags] || {}).with_content_type(kwargs[:content_type]).build
        @request_body.required = kwargs[:required]

        self
      end

      def build
        return {} if @request_body.content == {}

        @request_body
      end

      def reference
        return {} if @request_body.content == {}

        @specification.components.add_request_body(@request_body)
      end

      private

      def detect_request_body(oas_route)
        return unless (klass = Utils.find_model_from_route(oas_route.controller))

        from_model_class(klass:, required: true)
      end
    end
  end
end
