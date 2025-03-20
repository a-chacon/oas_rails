module OasRails
  module Spec
    class RequestBody
      include Specable
      include Hashable

      attr_accessor :description, :content, :required

      def initialize(specification)
        @specification = specification
        @description = ""
        @content = {} # a hash with media type objects
        @required = false
      end

      def oas_fields
        [:description, :content, :required]
      end

      def to_spec
        hash = {}

        # Add description
        hash[:description] = description unless description.nil? || description.empty?

        # Handle content with MediaType objects
        if content && !content.empty?
          content_hash = {}
          content.each do |key, media_type|
            content_hash[key] = if media_type.respond_to?(:to_spec)
                                  media_type.to_spec
                                else
                                  media_type
                                end
          end
          hash[:content] = content_hash
        end

        # Add required flag
        hash[:required] = required unless required.nil?

        hash
      end

      def hash_representation
        public_instance_variables.sort.to_h { |var| [var, instance_variable_get(var)] }
      end
    end
  end
end
