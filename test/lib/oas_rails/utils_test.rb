require "test_helper"

module OasRails
  class UtilsTest < Minitest::Test
    def test_detect_test_framework
      skip "Pending: Test needs to be updated for new framework detection logic"
      # Mock Rails and FactoryBot for testing
      Object.const_set(:Rails, Module.new) unless defined?(Rails)
      Object.const_set(:FactoryBot, Module.new) unless defined?(FactoryBot)
      Object.const_set(:ActiveRecord, Module.new) unless defined?(ActiveRecord)
      ActiveRecord.const_set(:Base, Class.new) unless defined?(ActiveRecord::Base)

      # Test with FactoryBot defined
      assert_equal :factory_bot, OasRails::Utils.detect_test_framework

      # Remove FactoryBot and test with ActiveRecord table
      Object.send(:remove_const, :FactoryBot)
      ActiveRecord::Base.define_singleton_method(:connection) do
        Struct.new(:table_exists?).new(true)
      end
      assert_equal :fixtures, OasRails::Utils.detect_test_framework

      # Remove ActiveRecord table and test unknown
      ActiveRecord::Base.define_singleton_method(:connection) do
        Struct.new(:table_exists?).new(false)
      end
      assert_equal :unknown, OasRails::Utils.detect_test_framework
    ensure
      Object.send(:remove_const, :Rails) if defined?(Rails)
      Object.send(:remove_const, :FactoryBot) if defined?(FactoryBot)
      Object.send(:remove_const, :ActiveRecord) if defined?(ActiveRecord)
    end

    def test_hash_to_json_schema
      schema = OasRails::Utils.hash_to_json_schema({ name: "String", age: 30 })
      assert_equal 'object', schema[:type]
      assert schema[:properties].key?(:name)
      assert schema[:properties].key?(:age)
      assert_empty schema[:required]
    end

    def test_status_to_integer
      assert_equal 200, OasRails::Utils.status_to_integer(nil)
      assert_equal 200, OasRails::Utils.status_to_integer('200')
      assert_equal 404, OasRails::Utils.status_to_integer(:not_found)
    end

    def test_get_definition
      assert_equal "The request has succeeded.", OasRails::Utils.get_definition(200)
      assert_equal "Definition not found for status code 999", OasRails::Utils.get_definition(999)
    end

    def test_class_to_symbol
      klass = Class.new { def self.name = "TestClass" }
      assert_equal :test_class, OasRails::Utils.class_to_symbol(klass)
    end

    def test_find_model_from_route
      Object.const_set(:User, Class.new)
      assert_equal User, OasRails::Utils.find_model_from_route('/users')
    ensure
      Object.send(:remove_const, :User) if defined?(User)
    end

    def test_active_record_class?
      # Mock an ActiveRecord class for testing
      Object.const_set(:ActiveRecord, Module.new)
      ActiveRecord.const_set(:Base, Class.new)
      ar_class = Class.new(ActiveRecord::Base)

      assert OasRails::Utils.active_record_class?(ar_class)
      refute OasRails::Utils.active_record_class?('String')
    ensure
      Object.send(:remove_const, :ActiveRecord) if defined?(ActiveRecord)
    end
  end
end
