require "test_helper"

module OasRails
  module Spec
    class MediaTypeTest < Minitest::Test
      def setup
        @specification = { schema: {}, example: {}, examples: {} }
        @media_type = MediaType.new(@specification)
      end

      def test_initialization
        assert_equal @specification, @media_type.instance_variable_get(:@specification)
        assert_equal({}, @media_type.schema)
        assert_equal({}, @media_type.example)
        assert_equal({}, @media_type.examples)
        assert_nil @media_type.encoding
      end

      def test_attribute_accessors
        @media_type.schema = { key: "value" }
        @media_type.example = { key: "value" }
        @media_type.examples = { key: "value" }
        @media_type.encoding = { key: "value" }

        assert_equal({ key: "value" }, @media_type.schema)
        assert_equal({ key: "value" }, @media_type.example)
        assert_equal({ key: "value" }, @media_type.examples)
        assert_equal({ key: "value" }, @media_type.encoding)
      end

      def test_oas_fields
        assert_equal [:schema, :example, :examples, :encoding], @media_type.oas_fields
      end
    end
  end
end
