require "test_helper"

module OasRails
  class UtilsTest < Minitest::Test
    def test_detect_test_framework
      assert_equal :fixtures, Utils.detect_test_framework
    end

    def test_hash_to_json_schema
      hash = { name: "Test", age: 30, active: true }
      schema = Utils.hash_to_json_schema(hash)

      assert_equal "object", schema[:type]
      assert_equal %i[name age active], schema[:properties].keys
      assert_equal [], schema[:required]
    end

    def test_ruby_type_to_json_type
      assert_equal "string", Utils.ruby_type_to_json_type("String")
      assert_equal "number", Utils.ruby_type_to_json_type("Integer")
      assert_equal "boolean", Utils.ruby_type_to_json_type("TrueClass")
      assert_equal "null", Utils.ruby_type_to_json_type("NilClass")
      assert_equal "object", Utils.ruby_type_to_json_type("Hash")
      assert_equal "string", Utils.ruby_type_to_json_type("UnknownClass")
    end

    def test_status_to_integer
      assert_equal 200, Utils.status_to_integer(nil)
      assert_equal 200, Utils.status_to_integer("200")
      assert_equal 404, Utils.status_to_integer(:not_found)
      assert_equal 422, Utils.status_to_integer("unprocessable_entity")
    end

    def test_get_definition
      assert_equal "The request has succeeded.", Utils.get_definition(200)
      assert_equal "The requested resource could not be found.", Utils.get_definition(404)
      assert_equal "Definition not found for status code 999", Utils.get_definition(999)
    end

    def test_class_to_symbol
      assert_equal :user, Utils.class_to_symbol(User)
    end

    def test_find_model_from_route
      # Assuming the dummy app has a User model
      assert_equal User, Utils.find_model_from_route("/users")
      assert_equal Admin::User, Utils.find_model_from_route("/admin/users") if defined?(Admin::User)
      assert_nil Utils.find_model_from_route("/nonexistent")
    end

    def test_active_record_class?
      assert Utils.active_record_class?(User)
      assert Utils.active_record_class?("User")
      refute Utils.active_record_class?("String")
      refute Utils.active_record_class?(String)
    end
  end
end
