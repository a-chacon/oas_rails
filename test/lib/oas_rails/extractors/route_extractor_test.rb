module OasRails
  module Builders
    class RouteExtractorTest < Minitest::Test
      def setup
        Extractors::RouteExtractor.clear_cache
        OasRails.config.ignored_actions = []
        OasRails.config.include_mode = :all
      end

      def teardown
        Extractors::RouteExtractor.clear_cache
        OasRails.config.ignored_actions = []
        OasRails.config.include_mode = :all
      end

      def test_without_custom_routes
        result = Extractors::RouteExtractor.host_routes
        assert_equal 16, result.count
      end

      def test_with_custom_controllers_actions
        init_count = Extractors::RouteExtractor.host_routes.count
        OasRails.config.ignored_actions = ["projects#index"]
        Extractors::RouteExtractor.clear_cache
        result = Extractors::RouteExtractor.host_routes.count
        assert_equal (init_count - 1), result
      end

      def test_with_custom_controller_only
        OasRails.config.ignored_actions = ["projects"]
        routes = Extractors::RouteExtractor.host_routes
        result = routes.select { |route| route.controller.include?("projects") }
        assert_equal 0, result.count
      end

      def test_extract_host_routes_with_tags_mode
        OasRails.config.include_mode = :with_tags
        result = Extractors::RouteExtractor.host_routes
        assert_equal 12, result.count
      end

      def test_extract_host_routes_explicit_mode
        OasRails.config.include_mode = :explicit
        result = Extractors::RouteExtractor.host_routes
        assert_equal 1, result.count
      end
    end
  end
end
