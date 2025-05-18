module OasRails
  module Spec
    class MediaType
      include Specable

      attr_accessor :schema, :example, :examples, :encoding

      # Initializes a new MediaType object.
      #
      # @param schema [Hash] the schema of the media type.
      # @param kwargs [Hash] additional keyword arguments.
      def initialize(specification)
        @specification = specification
        @schema = {}
        @example =  {}
        @examples = {}
      end

      def oas_fields
        [:schema, :example, :examples, :encoding]
      end
    end
  end
end
