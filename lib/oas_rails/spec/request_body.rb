module OasRails
  module Spec
    class RequestBody
      include Specable
      attr_accessor :description, :content, :required

      def initialize(description:, content:, required: false)
        @description = description
        @content = content # Should be an array of media type object
        @required = required
      end

      def oas_fields
        [:description, :content, :required]
      end

      class << self
        def from_tags(tag:, examples_tags: [])
          if tag.klass.ancestors.include? ActiveRecord::Base
            from_model_class(klass: tag.klass, description: tag.text, required: tag.required, examples_tags:)
          else
            # hash content to schema
            content = { "application/json": Spec::MediaType.new(schema: tag.schema, examples: Spec::MediaType.tags_to_examples(tags: examples_tags)) }
            new(description: tag.text, content:, required: tag.required)
          end
        end

        def from_model_class(klass:, **kwargs)
          content = { "application/json": Spec::MediaType.from_model_class(klass:, examples: Spec::MediaType.tags_to_examples(tags: kwargs[:examples_tags] || {})) }
          new(description: kwargs[:description] || klass.to_s, content:, required: kwargs[:required])
        end
      end
    end
  end
end
