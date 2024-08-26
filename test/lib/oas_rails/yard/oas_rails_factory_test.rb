require "test_helper"

module OasRails
  module YARD
    class OasRailsFactoryTest < ActiveSupport::TestCase
      def test_parse_tag_with_response_example
        response = OasRailsFactory.new.parse_tag_with_response_example(:response_example,
                                                                       '405 Error(405) [{message: "Hello", data: {availabilities: ["one", "two", "three"], dates: ["10-06-2020"]}}]')

        assert response.is_a?(ResponseExampleTag)
        assert_equal "405", response.code
        assert_equal '405 Error', response.text
        expected_hash = { message: "Hello", data: { availabilities: %w[one two three], dates: ["10-06-2020"] } }
        assert_equal expected_hash, response.content
      end
    end
  end
end
