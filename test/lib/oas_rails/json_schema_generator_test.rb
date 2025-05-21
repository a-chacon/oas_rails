require "test_helper"

module OasRails
  class JsonSchemaGeneratorTest < Minitest::Test
    def test_process_string
      input = "!Hash{message: !String, data: Hash{availabilities: Array<String>, details: Array<Hash{id: !Integer, name: !String}>}, metadata: Hash{id: !Integer, tags: Array<String>}}"
      result = JsonSchemaGenerator.process_string(input)

      assert_equal true, result[:required]
      assert_equal 'object', result[:json_schema][:type]
      assert_equal ['message'], result[:json_schema][:required]
      assert_equal 'string', result[:json_schema][:properties][:message][:type]
      assert_equal 'array', result[:json_schema][:properties][:data][:properties][:availabilities][:type]
      assert_equal %w[id name], result[:json_schema][:properties][:data][:properties][:details][:items][:required]
    end

    def test_parse_type_hash
      input = "!Hash{key: String, required_key: !Integer}"
      result = JsonSchemaGenerator.parse_type(input)

      assert_equal :object, result[:type]
      assert_equal true, result[:required]
      assert_equal false, result[:properties][:key][:required]
      assert_equal true, result[:properties][:required_key][:required]
    end

    def test_parse_type_array
      input = "Array<String>"
      result = JsonSchemaGenerator.parse_type(input)

      assert_equal :array, result[:type]
      assert_equal false, result[:required]
      assert_equal :string, result[:items][:type]
    end

    def test_parse_type_primitive
      input = "!Integer"
      result = JsonSchemaGenerator.parse_type(input)

      assert_equal :integer, result[:type]
      assert_equal true, result[:required]
    end

    def test_parse_object_properties
      input = "key1: String, key2: !Integer, key3: Array<Hash{nested: !Boolean}>"
      result = JsonSchemaGenerator.parse_object_properties(input)

      assert_equal 3, result.size
      assert_equal :string, result[:key1][:type]
      assert_equal true, result[:key2][:required]
      assert_equal :array, result[:key3][:type]
      assert_equal :object, result[:key3][:items][:type]
      assert_equal true, result[:key3][:items][:properties][:nested][:required]
    end

    def test_to_json_schema_object
      input = {
        type: :object,
        properties: {
          key1: { type: :string, required: false },
          key2: { type: :integer, required: true }
        }
      }
      result = JsonSchemaGenerator.to_json_schema(input)

      assert_equal 'object', result[:type]
      assert_equal ['key2'], result[:required]
      assert_equal 'string', result[:properties][:key1][:type]
      assert_equal 'integer', result[:properties][:key2][:type]
    end

    def test_to_json_schema_array
      input = {
        type: :array,
        items: { type: :string, required: false }
      }
      result = JsonSchemaGenerator.to_json_schema(input)

      assert_equal 'array', result[:type]
      assert_equal 'string', result[:items][:type]
    end

    def test_to_json_schema_primitive
      input = { type: :boolean, required: true }
      result = JsonSchemaGenerator.to_json_schema(input)

      assert_equal 'boolean', result[:type]
    end
  end
end
