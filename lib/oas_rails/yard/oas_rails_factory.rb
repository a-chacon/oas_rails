module OasRails
  module YARD
    class OasRailsFactory < ::YARD::Tags::DefaultFactory
      # Parses a tag that represents a request body.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [RequestBodyTag] The parsed request body tag object.
      def parse_tag_with_request_body(tag_name, text)
        description, klass, schema, required = extract_description_and_schema(text)
        RequestBodyTag.new(tag_name, description, klass, schema:, required:)
      end

      # Parses a tag that represents a request body example.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [RequestBodyExampleTag] The parsed request body example tag object.
      def parse_tag_with_request_body_example(tag_name, text)
        # Check if text is valid for parsing
        return RequestBodyExampleTag.new(tag_name, "Default request", content: {}) if text.nil? || text.strip.empty?

        # If the format indicates a multiline example
        # (has opening brace but missing or unbalanced closing brace)
        if text.include?('{') && (text.count('{') != text.count('}') || !text.include?('}'))
          description = text.split(/\s*\[/).first&.strip || "Request"

          # Try to find multiline content in docstring or source files
          content = extract_multiline_content_from_current_context(description)

          return RequestBodyExampleTag.new(tag_name, description, content: content) if content && !content.empty?
        end

        # Try to extract using the regex
        begin
          # Use a regex that supports multiline content with proper capture groups
          match = text.match(/^(.*?)\s*\[([^\]]*)\]\s*(.*)$/m)

          if match.nil?
            # If regex fails, try a simpler approach
            description = text.split(/\s*\[/).first&.strip || "Request"

            # One more attempt to find multiline content
            content = extract_multiline_content_from_current_context(description)
            return RequestBodyExampleTag.new(tag_name, description, content: content) if content && !content.empty?

            return RequestBodyExampleTag.new(tag_name, description, content: {})
          end

          description = match[1].strip
          type = match[2].strip
          content_text = match[3]

          # Check if content is just an opening brace (multiline content)
          if content_text.strip == '{' || content_text.strip == '{ ' ||
             (content_text.include?('{') && content_text.count('{') != content_text.count('}'))
            # Try to find multiline content in docstring
            content = extract_multiline_content_from_current_context(description)

            return RequestBodyExampleTag.new(tag_name, description, content: content) if content && !content.empty?

            return RequestBodyExampleTag.new(tag_name, description, content: {})
          end

          content = eval_content(content_text)
          RequestBodyExampleTag.new(tag_name, description, content: content)
        rescue StandardError => e
          # In case of parsing error, return a default request body example tag
          if defined?(Rails) && Rails.respond_to?(:logger)
            Rails.logger.error("Failed to parse request body example tag: #{e.message}\nText: #{text}")
          else
            puts "Failed to parse request body example tag: #{e.message}\nText: #{text}"
          end

          # One last attempt - try to extract the description and look for it in source files
          description = text.split(/\s*\[/).first&.strip || "Request"
          content = extract_multiline_content_from_current_context(description)

          return RequestBodyExampleTag.new(tag_name, description, content: content) if content && !content.empty?

          RequestBodyExampleTag.new(tag_name, "Default request", content: {})
        end
      end

      # Parses a tag that represents a parameter.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [ParameterTag] The parsed parameter tag object.
      def parse_tag_with_parameter(tag_name, text)
        name, location, schema, required, description = extract_name_location_schema_and_description(text)
        ParameterTag.new(tag_name, name, description, schema, location, required:)
      end

      # Parses a tag that represents a response.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [ResponseTag] The parsed response tag object.
      def parse_tag_with_response(tag_name, text)
        name, code, schema = extract_name_code_and_schema(text)
        ResponseTag.new(tag_name, code, name, schema)
      end

      # Parses a tag that represents a response example.
      # @param tag_name [String] The name of the tag.
      # @param text [String] The tag text to parse.
      # @return [ResponseExampleTag] The parsed response example tag object.
      def parse_tag_with_response_example(tag_name, text)
        # Check if text is valid for parsing
        return ResponseExampleTag.new(tag_name, "Default response", content: {}, code: "200") if text.nil? || text.strip.empty?

        # If the format indicates a multiline example
        # (has opening brace but missing or unbalanced closing brace)
        if text.include?('{') && (text.count('{') != text.count('}') || !text.include?('}'))
          description = text.split(/\s*\[/).first&.strip || "Response"

          # Extract code if present
          code = "200"
          if description =~ /\((\d+)\)/
            code = ::Regexp.last_match(1)
            description = description.sub(/\s*\(\d+\)/, '')
          end

          # Try to find multiline content in docstring or source files
          content = extract_multiline_content_from_current_context(description, "@response_example")

          return ResponseExampleTag.new(tag_name, description, content: content, code: code) if content && !content.empty?
        end

        # Try to extract name, code, and hash using the helper method
        begin
          description, code, hash = extract_name_code_and_hash(text)

          # Make sure we have all necessary values
          description = "Response" if description.nil? || description.strip.empty?
          code = "200" if code.nil? || code.strip.empty?

          # If we couldn't extract any content and it seems to be multiline
          if hash.empty? && text.include?('{') &&
             (text.count('{') != text.count('}') || !text.include?('}'))
            # Try to extract multiline content
            multiline_hash = extract_multiline_content_from_current_context(description, "@response_example")
            hash = multiline_hash if multiline_hash && !multiline_hash.empty?
          end

          hash = {} if hash.nil?

          ResponseExampleTag.new(tag_name, description, content: hash, code:)
        rescue StandardError => e
          # In case of parsing error, return a default response example tag
          if defined?(Rails) && Rails.respond_to?(:logger)
            Rails.logger.error("Failed to parse response example tag: #{e.message}\nText: #{text}")
          else
            puts "Failed to parse response example tag: #{e.message}\nText: #{text}"
          end

          # One last attempt - try to extract the description and look for it in source files
          description = text.split(/\s*\[/).first&.strip || "Response"
          code = "200"
          if description =~ /\((\d+)\)/
            code = ::Regexp.last_match(1)
            description = description.sub(/\s*\(\d+\)/, '')
          end

          content = extract_multiline_content_from_current_context(description, "@response_example")

          return ResponseExampleTag.new(tag_name, description, content: content, code: code) if content && !content.empty?

          ResponseExampleTag.new(tag_name, "Default response", content: {}, code: "200")
        end
      end

      private

      # Reusable method for extracting description, type, and content with an option to process content.
      # @param text [String] The text to parse.
      # @param process_content [Boolean] Whether to evaluate the content as a hash.
      # @return [Array] An array containing the description, type, and content or remaining text.
      def extract_description_type_and_content(text, process_content: false, expresion: /^(.*?)\s*\[(.*)\]\s*(.*)$/)
        match = text.match(expresion)
        raise ArgumentError, "Invalid tag format: #{text}" if match.nil?

        description = match[1].strip
        type = match[2].strip
        content = process_content ? eval_content(match[3].strip) : match[3].strip

        [description, type, content]
      end

      # Specific method to extract description and schema for request body tags.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the description, class, schema, and required flag.
      def extract_description_and_schema(text)
        description, type, = extract_description_type_and_content(text)
        klass, schema, required = type_text_to_schema(type)
        [description, klass, schema, required]
      end

      # Specific method to extract name, location, and schema for parameters.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the name, location, schema, and required flag.
      def extract_name_location_schema_and_description(text)
        match = text.match(/^(.*?)\s*\[(.*?)\]\s*(.*)$/)
        name, location = extract_text_and_parentheses_content(match[1].strip)
        schema, required = type_text_to_schema(match[2].strip)[1..]
        description = match[3].strip
        [name, location, schema, required, description]
      end

      # Specific method to extract name, code, and schema for responses.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the name, code, and schema.
      def extract_name_code_and_schema(text)
        name, code = extract_text_and_parentheses_content(text)
        _, type, = extract_description_type_and_content(text)
        schema = type_text_to_schema(type)[1]
        [name, code, schema]
      end

      # Specific method to extract name, code, and hash for responses examples.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the name, code, and hash.
      def extract_name_code_and_hash(text)
        # First get the name and code part
        name_with_code = text.split(/\s*\[/).first
        name, code = extract_text_and_parentheses_content(name_with_code&.strip)

        # Handle case where name and code extraction fails
        if name.nil? || code.nil?
          # Try to extract just the name without parentheses
          name = name_with_code&.strip
          code = "200" # Default to 200 if code can't be extracted
        end

        # Then get the hash content part which can be multiline
        # This regex matches anything in square brackets and grabs the content
        bracket_match = text.match(/\[(.*)\]/m)
        return [name, code, {}] unless bracket_match

        bracket_content = bracket_match[1].strip

        # Check if the content is a Ruby hash directly inside the brackets
        if bracket_content.start_with?('{') && bracket_content.end_with?('}')
          hash = eval_content(bracket_content)
          return [name, code, hash]
        end

        # Otherwise, try the standard approach with content after the bracket
        type_content = text.match(/\[(.*?)\]\s*(.*)/m)
        return [name, code, {}] unless type_content

        # Extract the content after the closing bracket
        content_text = type_content[2]

        # If content is just '{' or starts with '{' but is incomplete,
        # don't log a warning here - we'll handle this in the calling method
        # with the multiline extraction approach
        return [name, code, {}] if content_text.strip == '{' || content_text.strip == '{ '

        hash = eval_content(content_text)
        [name, code, hash]
      end

      # Evaluates a string as a hash, handling errors gracefully.
      # @param content [String] The content string to evaluate.
      # @return [Hash] The evaluated hash, or an empty hash if an error occurs.
      # rubocop:disable Security/Eval
      def eval_content(content)
        # Handle nil or empty content
        return {} if content.nil? || content.strip.empty?

        # Handle potential multiline content by normalizing the string
        content = content.strip

        # Special case: if content is just '{' or '{ ' (often happens with multiline YARD comments)
        return {} if ['{', '{ '].include?(content)

        # Fix for multiline content
        # If content contains newlines, we need to ensure it's a valid Ruby hash
        if content.include?("\n")
          # Remove all leading '#' characters that might be from YARD comments
          content = content.lines.map do |line|
            line.sub(/^\s*#\s*/, '').rstrip
          end.join(' ').strip
        end

        # Make sure braces are balanced
        open_count = content.count('{')
        close_count = content.count('}')

        # If braces aren't balanced, try to fix or return empty hash
        if open_count != close_count
          return {} unless open_count > close_count

          # Add missing closing braces
          content += '}' * (open_count - close_count)

          # Unbalanced in the other direction - can't properly fix this

        end

        begin
          result = eval(content)
          # Make sure we return a hash
          result.is_a?(Hash) ? result : {}
        rescue StandardError => e
          # Log the error for debugging purposes
          if defined?(Rails) && Rails.respond_to?(:logger)
            Rails.logger.error("Failed to parse example content: #{e.message}\nContent: #{content}")
          else
            puts "Failed to parse example content: #{e.message}\nContent: #{content}"
          end
          {}
        end
      end
      # rubocop:enable Security/Eval

      # Parses the position name and location from input text.
      # @param input [String] The input text to parse.
      # @return [Array] An array containing the name and location.
      def extract_text_and_parentheses_content(input)
        return unless input =~ /^(.+?)\(([^)]+)\)/

        text = ::Regexp.last_match(1).strip
        parenthesis_content = ::Regexp.last_match(2).strip
        [text, parenthesis_content]
      end

      # Extracts the text and whether it's required.
      # @param text [String] The text to parse.
      # @return [Array] An array containing the text and a required flag.
      def text_and_required(text)
        if text.start_with?('!')
          [text.sub(/^!/, ''), true]
        else
          [text, false]
        end
      end

      # Matches and validates a description and type from text.
      # @param text [String] The text to parse.
      # @return [MatchData] The match data from the regex.
      def description_and_type(text)
        match = text.match(/^(.*?)\s*\[(.*?)\]\s*(.*)$/)
        raise ArgumentError, "The request body tag is not valid: #{text}" if match.nil?

        match
      end

      # Checks if a given text refers to an ActiveRecord class.
      # @param text [String] The text to check.
      # @return [Boolean] True if the text refers to an ActiveRecord class, false otherwise.
      def active_record_class?(text)
        klass = text.constantize
        klass.ancestors.map(&:to_s).include? 'ActiveRecord::Base'
      rescue StandardError
        false
      end

      # Converts type text to a schema, checking if it's an ActiveRecord class.
      # @param text [String] The type text to convert.
      # @return [Array] An array containing the class, schema, and required flag.
      def type_text_to_schema(text)
        type_text, required = text_and_required(text)

        if active_record_class?(type_text)
          klass = type_text.constantize
          schema = Builders::EsquemaBuilder.build_outgoing_schema(klass:)
        else
          schema = JsonSchemaGenerator.process_string(type_text)[:json_schema]
          klass = Object
        end
        [klass, schema, required]
      end

      # Extract multiline content from the current YARD context
      # @param description [String] The description of the tag to find in the docstring
      # @param tag_type [String] The type of tag to look for, defaults to "@request_body_example"
      # @return [Hash, nil] The extracted content as a hash, or nil if not found
      def extract_multiline_content_from_current_context(description, tag_type = "@request_body_example")
        # First try to extract from the YARD Registry
        if defined?(::YARD::Registry) && ::YARD::Registry.respond_to?(:current)
          current_object = ::YARD::Registry.current
          if current_object && current_object.docstring
            # Find the tag in the docstring
            content = extract_multiline_hash_from_docstring(current_object.docstring.all, description, tag_type)
            return content if content && !content.empty?
          end
        end

        # Then try to extract from the current docstring parser
        if defined?(::YARD::DocstringParser) && ::YARD::DocstringParser.respond_to?(:current) && ::YARD::DocstringParser.current
          docstring = ::YARD::DocstringParser.current.text
          if docstring
            content = extract_multiline_hash_from_docstring(docstring.split("\n"), description, tag_type)
            return content if content && !content.empty?
          end
        end

        # Finally, try to extract from the source file
        if defined?(::YARD::Parser::SourceParser) && ::YARD::Parser::SourceParser.respond_to?(:parser)
          parser = ::YARD::Parser::SourceParser.parser
          if parser && parser.respond_to?(:file) && parser.file
            begin
              file = parser.file
              lines = File.readlines(file)

              # Find the line with our description
              tag_line = nil
              lines.each_with_index do |line, idx|
                if line.include?(tag_type) && line.include?(description)
                  tag_line = idx
                  break
                end
              end

              if tag_line
                # Extract the multiline hash
                hash = extract_multiline_hash_from_source(lines, tag_line)
                return hash if hash && !hash.empty?
              end
            rescue StandardError => e
              Rails.logger.error("Failed to extract multiline content from source: #{e.message}") if defined?(Rails) && Rails.respond_to?(:logger)
            end
          end
        end

        # If all failed, try one more approach - look through all controller files
        # Very Rails specific, but that's what we're targeting
        begin
          if defined?(Rails) && Rails.respond_to?(:root)
            controllers_path = File.join(Rails.root, 'app', 'controllers', '**', '*.rb')
            api_controllers_path = File.join(Rails.root, 'app', 'controllers', 'api', '**', '*.rb')

            # First search through API controllers as they're more likely to have OAS documentation
            [api_controllers_path, controllers_path].each do |glob_pattern|
              Dir.glob(glob_pattern).each do |controller_file|
                next unless File.exist?(controller_file)

                begin
                  lines = File.readlines(controller_file)
                  tag_line = nil

                  # Look for exact matches first
                  lines.each_with_index do |line, idx|
                    if line.include?(tag_type) && line.include?(description)
                      tag_line = idx
                      break
                    end
                  end

                  # If no exact match, try partial matches
                  if tag_line.nil?
                    lines.each_with_index do |line, idx|
                      next unless line.include?(tag_type) && (
                         description.include?(line.split('[').first.gsub(tag_type, '').strip) ||
                         line.split('[').first.gsub(tag_type, '').strip.include?(description)
                       )

                      tag_line = idx
                      break
                    end
                  end

                  if tag_line
                    hash = extract_multiline_hash_from_source(lines, tag_line)
                    return hash if hash && !hash.empty?
                  end
                rescue StandardError => e
                  Rails.logger.error("Error processing controller file #{controller_file}: #{e.message}") if defined?(Rails) && Rails.respond_to?(:logger)
                end
              end
            end
          end
        rescue StandardError => e
          Rails.logger.error("Failed in last attempt to extract multiline content: #{e.message}") if defined?(Rails) && Rails.respond_to?(:logger)
        end

        # If all failed, return empty hash
        {}
      end

      # Extract a multiline hash from docstring lines
      # @param lines [Array<String>] The docstring lines
      # @param description [String] The description to search for
      # @param tag_type [String] The type of tag to look for
      # @return [Hash] The extracted hash, or an empty hash if extraction fails
      def extract_multiline_hash_from_docstring(lines, description, tag_type = "@request_body_example")
        tag_line = nil

        # Find the line containing our tag
        lines.each_with_index do |line, idx|
          if line.include?(tag_type) && line.include?(description)
            tag_line = idx
            break
          end
        end

        return {} unless tag_line

        # Now extract the hash
        extract_multiline_hash_from_source(lines, tag_line)
      end

      # Extract a multiline hash from source lines starting at the given index
      # @param lines [Array<String>] The source lines
      # @param start_idx [Integer] The index to start looking from
      # @return [Hash] The extracted hash, or an empty hash if extraction fails
      def extract_multiline_hash_from_source(lines, start_idx)
        content_lines = []
        brace_count = 0
        in_hash = false

        # Search up to 30 lines after the tag line
        end_idx = [start_idx + 30, lines.length - 1].min

        (start_idx..end_idx).each do |i|
          line = lines[i].strip

          # Skip empty lines
          next if line.empty?

          # Skip until we find a line with opening brace
          unless in_hash
            next unless line.include?('{')

            in_hash = true
            # Extract just the part from the opening brace
            brace_idx = line.index('{')
            line = line[brace_idx..-1]

          end

          # Clean up the line (remove comment markers and whitespace)
          # This is important for YARD comments which start with #
          clean_line = line.sub(/^\s*#\s*/, '').strip

          # Skip empty lines after cleanup
          next if clean_line.empty?

          content_lines << clean_line

          # Count braces to properly detect the end of the hash
          brace_count += clean_line.count('{')
          brace_count -= clean_line.count('}')

          # If braces are balanced, we found the complete hash
          break if brace_count == 0 && clean_line.include?('}')
        end

        # If we didn't find a complete hash, log and return empty
        if brace_count != 0
          Rails.logger.error("Unbalanced braces in multiline content extraction") if defined?(Rails) && Rails.respond_to?(:logger)
          return {}
        end

        # Join the content lines with spaces
        content_text = content_lines.join(' ')

        # Extract the hash from the combined text
        if match = content_text.match(/(\{.*\})/m)
          hash_text = match[1]
          begin
            result = eval(hash_text)
            return result.is_a?(Hash) ? result : {}
          rescue StandardError => e
            Rails.logger.error("Failed to evaluate hash from multiline content: #{e.message}") if defined?(Rails) && Rails.respond_to?(:logger)
          end
        end

        {}
      end
    end
  end
end
