require "test_helper"

module OasRails
  module Extractors
    class RailsRouteExtractorTest < Minitest::Test
      def setup
        @extractor = RailsRouteExtractor.new
      end

      def test_host_routes
        routes = @extractor.host_routes
        assert_kind_of Array, routes
        refute_empty routes
      end

      def test_host_routes_by_path
        path = "/projects"
        routes = @extractor.host_routes_by_path(path)
        assert_kind_of Array, routes
      end

      def test_host_paths
        paths = @extractor.host_paths
        assert_kind_of Array, paths
        refute_empty paths
      end

      def test_clear_cache
        @extractor.host_routes
        @extractor.clear_cache
        assert_nil @extractor.instance_variable_get(:@host_routes)
        assert_nil @extractor.instance_variable_get(:@host_paths)
      end

      def test_valid_route_implementation?
        route = Rails.application.routes.routes.select { |r| r.name == "projects" }.first
        assert @extractor.send(:valid_route_implementation?, route)
      end

      def test_ignore_custom_actions
        route = Rails.application.routes.routes.first
        refute @extractor.send(:ignore_custom_actions, route)
      end
    end
  end
end
