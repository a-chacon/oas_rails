require "test_helper"

module OasRails
  class ConfigurationTest < ActiveSupport::TestCase
    def setup
      @config = Configuration.new
    end

    test "initializes with default values" do
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

    test "sets and gets servers" do
      servers = [{ url: "https://example.com", description: "Example Server" }]
      @config.servers = servers
      assert_equal 1, @config.servers.size
      assert_equal "https://example.com", @config.servers.first.url
      assert_equal "Example Server", @config.servers.first.description
    end

    test "sets and gets tags" do
      tags = [{ name: "Users", description: "Operations about users" }]
      @config.tags = tags
      assert_equal 1, @config.tags.size
      assert_equal "Users", @config.tags.first.name
      assert_equal "Operations about users", @config.tags.first.description
    end

    test "validates include_mode" do
      assert_nothing_raised { @config.include_mode = :with_tags }
      assert_nothing_raised { @config.include_mode = :explicit }
      assert_raises(ArgumentError) { @config.include_mode = :invalid_mode }
    end

    test "validates response_body_of_default" do
      assert_nothing_raised { @config.response_body_of_default = "String" }

      assert_raises(ArgumentError) { @config.response_body_of_default = 123 }
    end

    test "sets security_schema" do
      @config.security_schema = :api_key_header
      assert_equal 1, @config.security_schemas.size
      assert_equal "apiKey", @config.security_schemas[:api_key_header][:type]
    end

    test "ignores invalid security_schema" do
      @config.security_schema = :invalid_schema
      assert_empty @config.security_schemas
    end

    test "dynamic response_body_of_<error> setters and getters" do
      @config.response_body_of_not_found = "String"
      assert_equal "String", @config.response_body_of_not_found

      assert_equal @config.response_body_of_default, @config.response_body_of_unauthorized

      assert_raises(ArgumentError) { @config.response_body_of_forbidden = 123 }
    end

    test "all dynamic response_body_of_<error> methods are defined" do
      @config.possible_default_responses.each do |response|
        assert_respond_to @config, "response_body_of_#{response}="
        assert_respond_to @config, "response_body_of_#{response}"
      end
    end

    MockRouteExtractor = Struct.new(:host_routes, :host_routes_by_path, :clear_cache, :host_paths, :clean_route)

    test "validates route_extractor" do
      # Test with an object that responds to :routes (should work)
      mock_route_extractor = MockRouteExtractor.new([], [], proc {}, [], proc {})

      @config.route_extractor = mock_route_extractor

      assert_equal mock_route_extractor, @config.route_extractor

      # Test with an object that doesn't respond to :routes (should raise error)
      assert_raises(ArgumentError) { @config.route_extractor = "invalid" }
      assert_raises(ArgumentError) { @config.route_extractor = 123 }
      assert_raises(ArgumentError) { @config.route_extractor = Class.new }
    end
  end
end
