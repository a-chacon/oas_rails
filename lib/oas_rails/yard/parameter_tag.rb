module OasRails
  module YARD
    class ParameterTag < ::YARD::Tags::Tag
      attr_accessor :schema, :required, :location

      def initialize(tag_name, name, text, schema, location, required: false)
        super(tag_name, text, nil, name)
        @schema = schema
        @required = required
        @location = location
      end
    end
  end
end
