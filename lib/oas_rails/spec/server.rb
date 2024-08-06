module OasRails
  module Spec
    class Server
      include Specable
      attr_accessor :url, :description

      def initialize(url:, description:)
        @url = url
        @description = description
      end

      def oas_fields
        [:url, :description]
      end
    end
  end
end
