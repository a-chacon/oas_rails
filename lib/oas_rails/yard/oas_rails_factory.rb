module OasRails
  module YARD
    class OasRailsFactory < ::YARD::Tags::DefaultFactory
      ## parse_tag is a prefix used by YARD

      def parse_tag_with_request_body(tag_name, text)
        match = text.match(/^(.*?)\s*\[(.*?)\]\s*(.*)$/)
        if !match.nil?
          text = match[1].strip
          type, required = parse_type(match[2].strip)

          if type.constantize == Hash
            hash_string = match[3].strip

            begin
              hash = eval(hash_string)
              hash = Utils.hash_to_json_schema(hash)
            rescue StandardError
              hash = {}
            end
          end

          RequestBodyTag.new(tag_name, text, type.constantize, schema: hash, required:)
        else
          Rails.logger.debug("Error parsing request_body tag: #{text}")
        end
      end

      def parse_tag_with_request_body_example(tag_name, text)
        match = text.match(/^(.*?)\s*\[(.*?)\]\s*(.*)$/)
        if !match.nil?
          text = match[1].strip
          type = match[2]

          if type.constantize == Hash
            hash_string = match[3].strip

            begin
              hash = eval(hash_string)
            rescue StandardError
              hash = {}
            end
          end
          RequestBodyExampleTag.new(tag_name, text, content: hash)
        else
          Rails.logger.debug("Error parsing request body example tag: #{text}")
        end
      end

      def parse_tag_with_parameter(tag_name, text)
        match = text.match(/^(.*?)\s*\[(.*?)\]\s*(.*)$/)
        if !match.nil?
          text = match[1].strip
          name, location = parse_position_name(text)
          type, required = parse_type(match[2].strip)
          schema = Utils.type_to_schema(type)

          ParameterTag.new(tag_name, name, match[3].strip, schema, location, required:)
        else
          Rails.logger.debug("Error parsing request body example tag: #{text}")
        end
      end

      def parse_tag_with_response(tag_name, text)
        match = text.match(/^(.*?)\s*\[(.*?)\]\s*(.*)$/)
        if !match.nil?
          name, code = parse_position_name(match[1].strip)

          begin
            hash = parse_str_to_hash(match[3].strip)
            hash = Utils.hash_to_json_schema(hash)
          rescue StandardError
            hash = {}
          end

          ResponseTag.new(tag_name, code, name, hash)
        else
          Rails.logger.debug("Error parsing request body example tag: #{text}")
        end
      end

      def parse_position_name(input)
        return unless input =~ /^([^(]+)\((.*)\)$/

        name = ::Regexp.last_match(1)
        location = ::Regexp.last_match(2)
        [name, location]
      end

      def parse_type(type_string)
        if type_string.end_with?('!')
          [type_string.chomp('!'), true]
        else
          [type_string, false]
        end
      end

      def parse_str_to_hash(str)
        str = str.gsub(/^\{|\}$/, '') # Remove leading { and trailing }
        pairs = str.split(',').map(&:strip)

        pairs.each_with_object({}) do |pair, hash|
          key, value = pair.split(':').map(&:strip)
          key = key.to_sym
          hash[key] = case value
                      when 'String' then String
                      when 'Integer' then Integer
                      when 'Float' then Float
                      when 'Boolean' then [TrueClass, FalseClass]
                      when 'Array' then Array
                      when 'Hash' then Hash
                      when 'DateTime' then DateTime
                      else value
                      end
        end
      end
    end
  end
end
