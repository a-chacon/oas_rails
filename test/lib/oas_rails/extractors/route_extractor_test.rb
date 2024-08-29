module OasRails
  module Builders
    class RouteExtractorTest < Minitest::Test
      def test_without_custom_routes
        OasRails.config.ignored_actions = []
        result = Extractors::RouteExtractor.host_routes
        assert_equal 14, result.count
        Extractors::RouteExtractor.clear_cache

        OasRails.config.ignored_actions = ["projects#index"]
        result = Extractors::RouteExtractor.host_routes
        assert_equal 13, result.count
        Extractors::RouteExtractor.clear_cache

        OasRails.config.ignored_actions = ["projects"]
        result = Extractors::RouteExtractor.host_routes
        assert_equal 8, result.count
        Extractors::RouteExtractor.clear_cache
      end
    end
  end
end
