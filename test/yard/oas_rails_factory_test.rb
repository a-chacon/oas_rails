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
      end

      test 'parse_tag_with_request_body returns RequestBodyTag with ActiveRecord model' do
        text = 'The user to be created [!User]'
        tag = @factory.parse_tag_with_request_body('request_body', text)
        assert_instance_of RequestBodyTag, tag
        assert_equal true, tag.required
      end

      test 'parse_tag_with_request_body_example returns RequestBodyExampleTag' do
        text = 'A complete User. [Hash] {user: {name: "Luis", age: 30, password: "MyWeakPassword123"}}'
        tag = @factory.parse_tag_with_request_body_example('request_body_example', text)
        assert_instance_of RequestBodyExampleTag, tag
      end

      test 'parse_tag_with_parameter returns ParameterTag' do
        text = 'id(path) [!Integer] The user ID'
        tag = @factory.parse_tag_with_parameter('parameter', text)
        assert_instance_of ParameterTag, tag
        assert_equal true, tag.required
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

      test 'parse_tag_with_response_example returns ResponseExampleTag' do
        text = 'Invalid Email(422) [Hash] {success: "false", errors: [{field: "email", type: "email", detail: ["Invalid email"]}] }'
        tag = @factory.parse_tag_with_response_example('response_example', text)
        assert_instance_of ResponseExampleTag, tag
        assert_equal 'Invalid Email', tag.text
      end
    end
  end
end
