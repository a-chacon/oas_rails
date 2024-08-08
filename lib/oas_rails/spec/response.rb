module OasRails
  module Spec
    class Response
      include Specable
      include Hashable

      attr_accessor :code, :description, :content

      def initialize(specification)
        @specification = specification
        @description = ""
        @content = {} # Hash with {content: MediaType}
      end

      def oas_fields
        [:description, :content]
      end
    end
  end
end
