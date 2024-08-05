module OasRails
  module Spec
    class Server < Spec::Base
      attr_accessor :url, :description

      def initialize(url:, description:)
        @url = url
        @description = description
      end
    end
  end
end
