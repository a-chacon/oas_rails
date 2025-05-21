require "test_helper"

module OasRails
  class ActiveRecordExampleFinderTest < Minitest::Test
    # def setup
    #   @utils = Minitest::Mock.new
    #   @factory_bot = Minitest::Mock.new
    #   @file = Minitest::Mock.new
    #   @finder = ActiveRecordExampleFinder.new(context: :incoming, utils: @utils, factory_bot: @factory_bot, file: @file)
    # end
    #
    # def test_search_returns_empty_hash_for_unsupported_test_framework
    #   @utils.expect :detect_test_framework, :unknown
    #   assert_equal({}, @finder.search(User))
    # end
    #
    # def test_search_delegates_to_factory_bot_when_framework_is_factory_bot
    #   @utils.expect :detect_test_framework, :factory_bot
    #   @utils.expect :class_to_symbol, :user, [User]
    #   @factory_bot.expect :build_stubbed_list, [{ name: "Test" }], [:user, 1]
    #
    #   expected = { user1: { value: { user: { name: "Test" } } } }
    #   assert_equal expected, @finder.search(User)
    # end
    #
    # def test_search_delegates_to_fixtures_when_framework_is_fixtures
    #   @utils.expect :detect_test_framework, :fixtures
    #   @file.expect :read, "
    #     two:
    #       name: <%= 'Luis' %>
    #       email: luis@gmail.com
    #   ", [Pathname]
    #
    #   expected = { two: { value: { user: { "name" => "Luis", "email" => "luis@gmail.com" } } } }
    #   assert_equal(expected, @finder.search(User))
    # end
    #
    # def test_clean_example_object_filters_excluded_columns
    #   obj = { id: 1, name: "Test", password: "secret" }
    #   assert_equal({ name: "Test", password: "secret" }, @finder.clean_example_object(obj: obj))
    # end
  end
end
