module OasRails
  module Builders
    class RouteExtractorTest < Minitest::Test
      def test_without_custom_routes
        Extractors::RouteExtractor.clear_cache
        OasRails.config.ignored_actions = []
        result = Extractors::RouteExtractor.host_routes
        assert_equal 14, result.count
        Extractors::RouteExtractor.clear_cache
      end

      def test_with_custom_controllers_actions
        Extractors::RouteExtractor.clear_cache
        OasRails.config.ignored_actions = []
        init_count = Extractors::RouteExtractor.host_routes.count
        OasRails.config.ignored_actions = ["projects#index"]
        Extractors::RouteExtractor.clear_cache
        result = Extractors::RouteExtractor.host_routes.count
        assert_equal (init_count - 1), result
        Extractors::RouteExtractor.clear_cache
        OasRails.config.ignored_actions = []
      end

      def test_with_custom_controller_only
        Extractors::RouteExtractor.clear_cache
        OasRails.config.ignored_actions = ["projects"]
        routes = Extractors::RouteExtractor.host_routes
        result = routes.select { |route| route.controller.include?("projects") }
        assert_equal 0, result.count
        Extractors::RouteExtractor.clear_cache
        OasRails.config.ignored_actions = []
      end
    end
  end
end
