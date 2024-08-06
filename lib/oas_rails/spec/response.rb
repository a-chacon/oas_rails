module OasRails
  module Spec
    class Response
      include Specable
      attr_accessor :code, :description, :content

      def initialize(code:, description:, content:)
        @code = code
        @description = description
        @content = content # Hash with {content: MediaType}
      end

      def oas_fields
        [:code, :description, :content]
      end
    end
  end
end
