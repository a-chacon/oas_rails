module OasRails
  module Builders
    class OasRouteBuilder
      # Gems/frameworks (like Sorbet) may wrap methods at runtime, causing
      # +instance_method.source_location+ to point to the wrapper rather than
      # the original source file. We detect this and fall back to reading the
      # source file directly so that OasRails annotations remain readable.
      KNOWN_RUNTIME_WRAPPERS = %w[sorbet-runtime].freeze

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
        OasRails.config.prefix_path + OasRails.config.route_extractor.clean_route(@rails_route.path.spec.to_s)
      end

      def source_string
        controller_class.constantize.instance_method(method).source
      end

      def docstring
        comment = method_comment_safe
        comment_lines = comment.lines
        processed_lines = comment_lines.map { |line| line.sub(/^# /, '') }

        filtered_lines = processed_lines.reject do |line|
          line.include?('rubocop') ||
            line.include?('TODO')
        end

        ::YARD::Docstring.parser.parse(filtered_lines.join).to_docstring
      end

      def tags
        method_tags = parse_tags(method_comment_safe)
        class_tags = parse_tags(class_comment_safe)

        method_tags + class_tags
      end

      def parse_tags(comment)
        lines = comment.lines.map { |line| line.sub(/^# /, '') }
        ::YARD::Docstring.parser.parse(lines.join).tags
      end

      # Returns the method-level comment, falling back to direct source-file
      # reading when the method has been wrapped by a runtime library
      # (e.g. Sorbet's +sig+ blocks replace the method at runtime, causing
      # +instance_method.source_location+ to point to sorbet-runtime internals
      # rather than the controller file).
      def method_comment_safe
        unbound = controller_class.constantize.instance_method(method)
        return unbound.comment unless wrapped_by_runtime?(unbound)

        read_comment_from_source(method)
      end

      def class_comment_safe
        unbound = controller_class.constantize.instance_method(method)
        return unbound.class_comment unless wrapped_by_runtime?(unbound)

        read_comment_from_source(:class)
      end

      # Returns true when the unbound method's source_location points to a
      # known runtime wrapper gem rather than the application source.
      def wrapped_by_runtime?(unbound_method)
        loc = unbound_method.source_location
        return false unless loc

        KNOWN_RUNTIME_WRAPPERS.any? { |wrapper| loc.first.include?(wrapper) }
      end

      # Reads the contiguous comment block above a +def+ or +class+ line in
      # the controller source file, skipping over non-comment lines such as
      # +sig { void }+ injected by Sorbet.
      #
      # When +target+ is +:class+, finds the class declaration line.
      # Otherwise, finds +def <target>+.
      def read_comment_from_source(target)
        source_file = find_source_file
        return "" unless source_file

        lines = File.readlines(source_file)
        target_idx = if target == :class
                       lines.index { |l| l.match?(/^\s*class\s+\w+/) }
                     else
                       lines.index { |l| l.match?(/^\s+def #{Regexp.escape(target.to_s)}\b/) }
                     end
        return "" unless target_idx

        collect_comments_before(lines, target_idx)
      rescue StandardError
        ""
      end

      # Walk backwards from +target_idx+ collecting contiguous comment lines,
      # skipping blank lines and non-comment lines (like +sig { void }+).
      # Leading whitespace is stripped so output matches method_source format.
      def collect_comments_before(lines, target_idx)
        comment_lines = []
        idx = target_idx - 1

        while idx >= 0
          stripped = lines[idx].strip
          if stripped.start_with?("#")
            comment_lines.unshift("#{stripped}\n")
          elsif stripped.empty? || stripped.match?(/\Asig\s*[{(]/)
            # skip blank lines and Sorbet sig blocks
          else
            break
          end
          idx -= 1
        end

        comment_lines.join
      end

      # Attempts to locate the controller source file by scanning the Rails
      # autoload paths, since +source_location+ is unavailable when wrapped.
      def find_source_file
        # Try using ancestors with valid source locations first
        klass = controller_class.constantize
        klass.instance_methods(false).each do |m|
          loc = klass.instance_method(m).source_location
          next unless loc && !wrapped_by_runtime?(klass.instance_method(m))

          return loc.first
        end

        # Fall back to searching autoload paths for the expected filename
        expected_path = "#{controller}_controller.rb"
        Rails.autoloaders.main.dirs.each do |dir|
          candidate = File.join(dir, expected_path)
          return candidate if File.exist?(candidate)
        end

        nil
      end
    end
  end
end
