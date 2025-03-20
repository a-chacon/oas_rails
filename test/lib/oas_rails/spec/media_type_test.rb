require "test_helper"

module OasRails
  module Spec
    class MediaTypeTest < ActiveSupport::TestCase
      test "create one example for one tag" do
        tag = OasRails::YARD::OasRailsFactory.new.parse_tag_with_request_body_example(
          :request_body_example,
          'basic user [Hash] {user: {name: "Luis", email: "luis@gmail.ocom"}}'
        )

        result = Spec::MediaType.tags_to_examples(tags: [tag])

        assert_equal(
          { "basic_user" => { "summary" => "basic user", "value" => { user: { name: "Luis", email: "luis@gmail.ocom" } } } },
          result
        )
      end

      test "create one example for multiline tag" do
        multiline_text = <<~TEXT
          complex user [Hash] {
            user: {
              name: "John Doe",
              email: "john@example.com",
              addresses: [
                {
                  street: "123 Main St",
                  city: "San Francisco"
                }
              ]
            }
          }
        TEXT

        tag = OasRails::YARD::OasRailsFactory.new.parse_tag_with_request_body_example(
          :request_body_example,
          multiline_text
        )

        result = Spec::MediaType.tags_to_examples(tags: [tag])

        assert_equal "complex user", result["complex_user"]["summary"]
        assert_equal "John Doe", result["complex_user"]["value"][:user][:name]
        assert_equal "john@example.com", result["complex_user"]["value"][:user][:email]
        assert_equal "123 Main St", result["complex_user"]["value"][:user][:addresses][0][:street]
        assert_equal "San Francisco", result["complex_user"]["value"][:user][:addresses][0][:city]
      end

      # test "create media type from model class" do
      #   media_type = Spec::MediaType.from_model_class(klass: User)
      #
      #   assert_instance_of Spec::MediaType, media_type
      #   assert_equal "object", media_type.schema[:type]
      #   assert_includes media_type.schema[:properties], "user"
      #   assert_kind_of Hash, media_type.schema[:properties]["user"]
      #   assert_empty media_type.schema[:properties]["user"]["required"]
      # end
      #
      # test "search for examples using FactoryBot" do
      #   utils = mock_detect_test_framework(:factory_bot)
      #   examples = Spec::MediaType.search_for_examples_in_tests(klass: User, utils:)
      #
      #   assert_equal 3, examples.size
      #
      #   utils.verify
      # end
      #
      # test "search for examples using fixtures" do
      #   utils = mock_detect_test_framework(:fixtures)
      #   examples = Spec::MediaType.search_for_examples_in_tests(klass: User, utils:)
      #
      #   assert_equal 2, examples.size
      #
      #   utils.verify
      # end
      #
      # test "search for examples with unrecognized test framework" do
      #   mock_utils = Minitest::Mock.new
      #   mock_utils.expect :detect_test_framework, :unknown_framework
      #
      #   examples = Spec::MediaType.search_for_examples_in_tests(klass: User, utils: mock_utils)
      #
      #   assert_empty examples
      #
      #   mock_utils.verify
      # end
      #
      # private
      #
      # def mock_detect_test_framework(should_respond)
      #   mock_utils = Minitest::Mock.new
      #   mock_utils.expect :detect_test_framework, should_respond
      #   mock_utils
      # end
    end
  end
end
