require 'test_helper'

module OasRails
  module YARD
    class OasRailsFactoryTest < ActiveSupport::TestCase
      def setup
        @factory = OasRailsFactory.new
      end

      test 'parse_tag_with_request_body returns RequestBodyTag with hash structure' do
        text = 'The user to be created [!Hash{user: Hash{name: String, age: Integer, password: String}}]'
        tag = @factory.parse_tag_with_request_body('request_body', text)

        assert_instance_of RequestBodyTag, tag
        assert_equal true, tag.required
        assert_equal 'request_body', tag.tag_name
        assert_equal 'The user to be created', tag.text
        assert_nil tag.name
        assert_nil tag.types
      end

      test 'parse_tag_with_request_body handles optional parameters' do
        text = 'The user to be created [Hash{user: Hash{name: String, age: Integer, password: String}}]'
        tag = @factory.parse_tag_with_request_body('request_body', text)

        assert_instance_of RequestBodyTag, tag
        assert_equal false, tag.required
      end

      test 'parse_tag_with_request_body raises error for malformed input' do
        text = 'The user to be created [!Hash{user: Hash{name: String, age: Integer, password: String}'
        assert_raises(ArgumentError) do
          @factory.parse_tag_with_request_body('request_body', text)
        end
      end

      test 'parse_tag_with_request_body returns RequestBodyTag with ActiveRecord model' do
        text = 'The user to be created [!User]'
        tag = @factory.parse_tag_with_request_body('request_body', text)
        assert_instance_of RequestBodyTag, tag
        assert_equal true, tag.required
      end

      test 'parse_tag_with_request_body_example returns RequestBodyExampleTag with correct structure' do
        text = 'A complete User. [Hash] {user: {name: "Luis", age: 30, password: "MyWeakPassword123"}}'
        tag = @factory.parse_tag_with_request_body_example('request_body_example', text)

        assert_instance_of RequestBodyExampleTag, tag
        assert_equal 'request_body_example', tag.tag_name
        assert_equal 'A complete User.', tag.text
        assert_nil tag.name
        assert_nil tag.types
        assert_equal(
          { user: { name: 'Luis', age: 30, password: 'MyWeakPassword123' } },
          tag.content
        )
      end

      test 'parse_tag_with_parameter returns ParameterTag with all attributes' do
        text = 'id(path) [!Integer] The user ID'
        tag = @factory.parse_tag_with_parameter('parameter', text)

        assert_instance_of ParameterTag, tag
        assert_equal 'parameter', tag.tag_name
        assert_equal 'The user ID', tag.text
        assert_equal 'id', tag.name
        assert_equal 'path', tag.location
        assert_equal true, tag.required
        assert_nil tag.types
        assert_equal({ type: 'integer' }, tag.schema)
      end

      test 'parse_tag_with_parameter appends [] to query array parameters' do
        text = 'ids(query) [!Array<Integer>] List of user IDs'
        tag = @factory.parse_tag_with_parameter('parameter', text)
        assert_instance_of ParameterTag, tag
        assert_equal 'ids[]', tag.name
        assert_equal 'query', tag.location
        assert_equal 'array', tag.schema[:type]
      end

      test 'parse_tag_with_response returns ResponseTag' do
        text = 'User not found by the provided Id(404) [Hash{success: Boolean, message: String}]'
        tag = @factory.parse_tag_with_response('response', text)
        assert_instance_of ResponseTag, tag
        assert_equal "404", tag.name
      end

      test 'parse_tag_with_response returns ResponseTag using array as response' do
        text = 'List of Users(200) [Array<User>]'
        tag = @factory.parse_tag_with_response('response', text)
        assert_instance_of ResponseTag, tag
        assert_equal "200", tag.name
        assert_equal "response", tag.tag_name
        assert_equal "List of Users", tag.text
        assert_nil tag.types
        assert_equal(
          {
            type: "array",
            items: {
              "type" => "object",
              "title" => "User",
              "properties" => {
                "id" => { "type" => "integer" },
                "name" => { "type" => %w[string null] },
                "email" => { "type" => %w[string null] },
                "password_digest" => { "type" => %w[string null] }
              },
              "additionalProperties" => false,
              "required" => %w[id name email password_digest]
            }
          },
          tag.schema
        )
      end

      test 'parse_tag_with_response_example returns ResponseExampleTag' do
        text = 'Invalid Email(422) [Hash] {success: "false", errors: [{field: "email", type: "email", detail: ["Invalid email"]}] }'
        tag = @factory.parse_tag_with_response_example('response_example', text)
        assert_instance_of ResponseExampleTag, tag
        assert_equal 'Invalid Email', tag.text
      end
    end
  end
end
