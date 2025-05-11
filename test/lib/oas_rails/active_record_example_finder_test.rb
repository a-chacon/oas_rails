require "test_helper"

module OasRails
  class ActiveRecordExampleFinderTest < ActiveSupport::TestCase
    def setup
      @utils = Minitest::Mock.new
      @factory_bot = Minitest::Mock.new
      @file = Minitest::Mock.new
      @finder = ActiveRecordExampleFinder.new(context: :incoming, utils: @utils, factory_bot: @factory_bot, file: @file)
    end

    test "search returns empty hash for unsupported test framework" do
      @utils.expect :detect_test_framework, :unknown
      assert_equal({}, @finder.search(User))
    end

    test "search delegates to factory_bot when framework is factory_bot" do
      @utils.expect :detect_test_framework, :factory_bot
      @utils.expect :class_to_symbol, :user, [User]
      @factory_bot.expect :build_stubbed_list, [{ name: "Test" }], [:user, 1]

      expected = { user1: { value: { user: { name: "Test" } } } }
      assert_equal expected, @finder.search(User)
    end

    test "search delegates to fixtures when framework is fixtures" do
      @utils.expect :detect_test_framework, :fixtures
      @file.expect :read, "
        two:
          name: <%= 'Luis' %>
          email: luis@gmail.com
      ", [Pathname]

      expected = { two: { value: { user: { "name" => "Luis", "email" => "luis@gmail.com" } } } }
      assert_equal(expected, @finder.search(User))
    end

    test "clean_example_object filters excluded columns" do
      obj = { id: 1, name: "Test", password: "secret" }
      assert_equal({ name: "Test", password: "secret" }, @finder.clean_example_object(obj: obj))
    end
  end
end
