module OasRails
  module Spec
    class Reference
      include Specable
      attr_reader :ref

      def initialize(ref)
        @ref = ref
      end

      def to_spec
        { '$ref' => @ref }
      end

      def as_json(options = nil)
        to_spec
      end

      def empty?
        false # A reference is never considered empty
      end
    end
  end
end
