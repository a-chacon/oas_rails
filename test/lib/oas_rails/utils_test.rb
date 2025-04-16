require "test_helper"

module OasRails
  class UtilsTest < ActiveSupport::TestCase
    test "detect_test_framework" do
      result = OasRails::Utils.detect_test_framework
      assert_equal :factory_bot, result
    end

    test "hash to schema" do
      result = OasRails::Utils.hash_to_json_schema({ name: "String", coords: "Array<Float>" })
      assert result.key? :properties
      assert result.key? :type
    end

    test "status to integer with unprocessable entity/content" do
      assert_equal 422, OasRails::Utils.status_to_integer(:unprocessable_entity)
      assert_equal 422, OasRails::Utils.status_to_integer(:unprocessable_content) if Gem.loaded_specs['rack'].version > Gem::Version.create('3.1')
    end
  end
end
