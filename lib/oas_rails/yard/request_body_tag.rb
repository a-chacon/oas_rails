module OasRails
  module YARD
    class RequestBodyTag < ::YARD::Tags::Tag
      attr_accessor :klass, :schema, :required, :content_type

      def initialize(tag_name, text, klass, schema: {}, required: false, content_type: 'application/json')
        # initialize(tag_name, text, types = nil, name = nil)
        super(tag_name, text, nil, nil)
        @klass = klass
        @schema = schema
        @required = required
        @content_type = content_type
      end
    end
  end
end
