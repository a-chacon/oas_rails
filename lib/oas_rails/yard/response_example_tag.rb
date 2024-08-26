module OasRails
  module YARD
    class ResponseExampleTag < ExampleTag
      attr_accessor :code

      def initialize(tag_name, text, content: {}, code: 200)
        super(tag_name, text, content:)
        @code = code
      end
    end
  end
end
