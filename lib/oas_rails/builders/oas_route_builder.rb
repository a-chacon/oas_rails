module OasRails
  module Builders
    class OasRouteBuilder
      def self.build_from_rails_route(rails_route)
        new(rails_route).build
      end

      def initialize(rails_route)
        @rails_route = rails_route
      end

      def build
        OasCore::OasRoute.new(
          controller: controller,
          method_name: method,
          verb: verb,
          path: path,
          docstring: docstring,
          source_string: source_string,
          tags: tags
        )
      end

      private

      def controller_class
        "#{@rails_route.defaults[:controller].camelize}Controller"
      end

      def controller
        @rails_route.defaults[:controller]
      end

      def method
        @rails_route.defaults[:action]
      end

      def verb
        @rails_route.verb
      end

      def path
        OasRails.config.route_extractor.clean_route(@rails_route.path.spec.to_s)
      end

      def source_string
        controller_class.constantize.instance_method(method).source
      end

      def docstring
        comment_lines = controller_class.constantize.instance_method(method).comment.lines
        processed_lines = comment_lines.map { |line| line.sub(/^# /, '') }

        filtered_lines = processed_lines.reject do |line|
          line.include?('rubocop') ||
            line.include?('TODO')
        end

        ::YARD::Docstring.parser.parse(filtered_lines.join).to_docstring
      end

      def tags
        method_comment = controller_class.constantize.instance_method(method).comment
        class_comment = controller_class.constantize.instance_method(method).class_comment

        method_tags = parse_tags(method_comment)
        class_tags = parse_tags(class_comment)

        method_tags + class_tags
      end

      def parse_tags(comment)
        lines = comment.lines.map { |line| line.sub(/^# /, '') }
        ::YARD::Docstring.parser.parse(lines.join).tags
      end
    end
  end
end
