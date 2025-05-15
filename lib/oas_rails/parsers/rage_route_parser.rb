module OasRails
  module Parsers
    class RageRouteParser
      def self.build_from_rage_route(rage_route)
        new(rage_route).build
      end

      def initialize(rage_route)
        @rage_route = rage_route
      end

      def build
        OasRoute.new(
          controller_class: controller_class,
          controller_action: controller_action,
          controller: controller,
          controller_path: controller_path,
          method: method,
          verb: verb,
          path: path,
          rails_route: @rage_route,
          docstring: docstring,
          source_string: source_string,
          tags: tags
        )
      end

      private

      def controller_class
        "#{@rage_route[:meta][:controller].camelize}Controller"
      end

      def controller_action
        "#{controller_class}##{@rage_route[:meta][:action]}"
      end

      def controller
        @rage_route[:meta][:controller]
      end

      # TODO: remove. aparently is not in use.
      def controller_path
        ""
      end

      def method
        @rage_route[:meta][:action]
      end

      def verb
        @rage_route[:method]
      end

      def path
        @rage_route[:path].to_s.gsub('(.:format)', '').gsub(/:\w+/) { |match| "{#{match[1..]}}" }
      end

      def source_string
        controller_class.constantize.instance_method(method).source
      end

      def docstring
        comment_lines = controller_class.constantize.instance_method(method).comment.lines
        processed_lines = comment_lines.map { |line| line.sub(/^# /, '') }
        ::YARD::Docstring.parser.parse(processed_lines.join).to_docstring
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
