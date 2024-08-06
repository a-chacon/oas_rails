module OasRails
  module Spec
    class Tag
      include Specable

      attr_accessor :name, :description

      def initialize(name:, description:)
        @name = name.titleize
        @description = description
      end

      def oas_fields
        [:name, :description]
      end
    end
  end
end
