module OasRails
  module Spec
    class Parameter
      include Specable
      include Hashable

      STYLE_DEFAULTS = { query: 'form', path: 'simple', header: 'simple', cookie: 'form' }.freeze

      attr_accessor :name, :style, :description, :required, :schema
      attr_reader :in

      def initialize(specification)
        @specification = specification
        @name = ""
        @in = ""
        @description = ""
        @required = false
        @style = ""
        @schema = { type: 'string' }
      end

      def in=(value)
        @in = value
        @style = STYLE_DEFAULTS[@in.to_sym]
        @required = true if value == "path"
      end

      def required?
        @in == 'path'
      end

      def oas_fields
        [:name, :in, :description, :required, :schema, :style]
      end
    end
  end
end
