module OasRails
  module YARD
    class RequestBodyTag < ::YARD::Tags::Tag
      attr_accessor :klass, :schema, :required

      def initialize(tag_name, text, klass, schema: {}, required: false)
        # initialize(tag_name, text, types = nil, name = nil)
        super(tag_name, text, nil, nil)
        @klass = klass
        @schema = schema
        @required = required
      end
    end
  end
end
