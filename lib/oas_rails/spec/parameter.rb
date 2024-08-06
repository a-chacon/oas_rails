module OasRails
  module Spec
    class Parameter
      include Specable
      STYLE_DEFAULTS = { query: 'form', path: 'simple', header: 'simple', cookie: 'form' }.freeze

      attr_accessor :name, :in, :style, :description, :required, :schema

      def initialize(name:, location:, description:, **kwargs)
        @name = name
        @in = location
        @description = description

        @required = kwargs[:required] || required?
        @style = kwargs[:style] || default_from_in
        @schema = kwargs[:schema] || { type: 'string' }
      end

      def self.from_path(path:, param:)
        new(name: param, location: 'path',
            description: "#{param.split('_')[-1].titleize} of existing #{extract_word_before(path, param).singularize}.")
      end

      def self.extract_word_before(string, param)
        regex = %r{/(\w+)/\{#{param}\}}
        match = string.match(regex)
        match ? match[1] : nil
      end

      def default_from_in
        STYLE_DEFAULTS[@in.to_sym]
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
