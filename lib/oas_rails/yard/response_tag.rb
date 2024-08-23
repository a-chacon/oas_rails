module OasRails
  module YARD
    class ResponseTag < ::YARD::Tags::Tag
      attr_accessor :schema

      def initialize(tag_name, name, text, schema)
        super(tag_name, text, nil, name)
        @schema = schema
      end
    end
  end
end
