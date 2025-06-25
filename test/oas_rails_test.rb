require "test_helper"

class OasRailsTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert OasRails::VERSION
  end

  class MockRouteExtractor < OasRails::Extractors::RouteExtractor
    def self.host_routes
      super.select { |route| route.controller.include?("users") }
    end
  end

  test "it builds with the configured route extractor" do
    config = OasRails::Configuration.new
    config.route_extractor = MockRouteExtractor

    OasRails.stub(:config, config) do
      custom_routes = OasRails.config.route_extractor.host_routes
      assert custom_routes.all? { |route| route.controller.include?("users") }, "Expected to get user routes only"

      oas_core_mock = Minitest::Mock.new
      oas_core_mock.expect(:build, nil, [custom_routes, { oas_source: {} }])
      OasCore.stub(:build, ->(*args) { oas_core_mock.build(*args) }) do
        OasRails.build
      end
      oas_core_mock.verify
    end
  end
end
