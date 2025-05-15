module OasRails
  module Spec
    class PathItem
      include Specable
      attr_reader :get, :post, :put, :patch, :delete

      def initialize(specification)
        @specification = specification
        @get = nil
        @post = nil
        @put = nil
        @patch = nil
        @delete = nil
      end

      def add_operation(http_method, operation)
        instance_variable_set("@#{http_method}", operation)
      end

      def oas_fields
        OasRails.config.http_verbs
      end
    end
  end
end
