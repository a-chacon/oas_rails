require "test_helper"

module OasRails
  class ConfigurationTest < Minitest::Test
    def setup
      @config = Configuration.new
    end

    def test_initializes_with_default_values
      assert_equal "3.1.0", @config.instance_variable_get(:@swagger_version)
      assert_equal "/", @config.api_path
      assert_equal [], @config.ignored_actions
      assert_equal true, @config.autodiscover_request_body
      assert_equal true, @config.autodiscover_responses
      assert_equal true, @config.authenticate_all_routes_by_default
      assert_equal [:get, :post, :put, :patch, :delete], @config.http_verbs
      assert_equal "Hash{ status: !Integer, error: String }", @config.response_body_of_default
      assert_equal :rails, @config.rapidoc_theme
      assert_equal :all, @config.include_mode
    end

    def test_sets_and_gets_servers
      servers = [{ url: "https://example.com", description: "Example Server" }]
      @config.servers = servers
      assert_equal 1, @config.servers.size
      assert_equal "https://example.com", @config.servers.first.url
      assert_equal "Example Server", @config.servers.first.description
    end

    def test_sets_and_gets_tags
      tags = [{ name: "Users", description: "Operations about users" }]
      @config.tags = tags
      assert_equal 1, @config.tags.size
      assert_equal "Users", @config.tags.first.name
      assert_equal "Operations about users", @config.tags.first.description
    end

    def test_validates_include_mode
      @config.include_mode = :with_tags
      @config.include_mode = :explicit
      assert_raises(ArgumentError) { @config.include_mode = :invalid_mode }
    end

    def test_validates_response_body_of_default
      @config.response_body_of_default = "String"
      assert_raises(ArgumentError) { @config.response_body_of_default = 123 }
    end

    def test_sets_security_schema
      @config.security_schema = :api_key_header
      assert_equal 1, @config.security_schemas.size
      assert_equal "apiKey", @config.security_schemas[:api_key_header][:type]
    end

    def test_ignores_invalid_security_schema
      @config.security_schema = :invalid_schema
      assert_empty @config.security_schemas
    end

    def test_dynamic_response_body_of_error_setters_and_getters
      @config.response_body_of_not_found = "String"
      assert_equal "String", @config.response_body_of_not_found

      assert_equal @config.response_body_of_default, @config.response_body_of_unauthorized

      assert_raises(ArgumentError) { @config.response_body_of_forbidden = 123 }
    end

    def test_all_dynamic_response_body_of_error_methods_are_defined
      @config.possible_default_responses.each do |response|
        assert_respond_to @config, "response_body_of_#{response}="
        assert_respond_to @config, "response_body_of_#{response}"
      end
    end
  end
end
