module OasRails
  module Builders
    class ParameterBuilder
      def initialize(specification)
        @specification = specification
        @parameter = Spec::Parameter.new(specification)
      end

      def from_path(path, param)
        @parameter.name = param
        @parameter.in = 'path'
        @parameter.description = "#{param.split('_')[-1].titleize} of existing #{extract_word_before(path, param).singularize}."

        self
      end

      def extract_word_before(string, param)
        regex = %r{/([\w-]+)/\{#{param}\}}
        match = string.match(regex)
        match ? match[1] : ""
      end

      def build
        @parameter
      end
    end
  end
end
