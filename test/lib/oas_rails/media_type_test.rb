require "test_helper"

module OasRails
  class MediaTypeTest < ActiveSupport::TestCase
    test "create one example for one tag" do
      tag = YARD::OasYARDFactory.new.parse_tag_with_request_body_example(
        :request_body_example,
        'basic user [Hash] {user: {name: "Luis", email: "luis@gmail.ocom"}}'
      )

      result = MediaType.tags_to_examples(tags: [tag])

      assert_equal(
        { "basic_user" => { "summary" => "basic user", "value" => { user: { name: "Luis", email: "luis@gmail.ocom" } } } },
        result
      )
    end

    test "create media type from model class" do
      media_type = MediaType.from_model_class(klass: User)

      assert_instance_of MediaType, media_type
      assert_equal "object", media_type.schema[:type]
      assert_includes media_type.schema[:properties], "user"
      assert_kind_of Hash, media_type.schema[:properties]["user"]
      assert_empty media_type.schema[:properties]["user"]["required"]
    end

    test "search for examples using FactoryBot" do
      utils = mock_detect_test_framework(:factory_bot)
      examples = MediaType.search_for_examples_in_tests(klass: User, utils:)

      assert_equal 3, examples.size

      utils.verify
    end

    test "search for examples using fixtures" do
      utils = mock_detect_test_framework(:fixtures)
      examples = MediaType.search_for_examples_in_tests(klass: User, utils:)

      assert_equal 2, examples.size

      utils.verify
    end

    test "search for examples with unrecognized test framework" do
      mock_utils = Minitest::Mock.new
      mock_utils.expect :detect_test_framework, :unknown_framework

      examples = MediaType.search_for_examples_in_tests(klass: User, utils: mock_utils)

      assert_empty examples

      mock_utils.verify
    end

    private

    def mock_detect_test_framework(should_respond)
      mock_utils = Minitest::Mock.new
      mock_utils.expect :detect_test_framework, should_respond
      mock_utils
    end
  end
end
