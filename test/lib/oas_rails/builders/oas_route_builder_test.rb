require 'test_helper'

module OasRails
  module Builders
    class OasRouteBuilderTest < ActiveSupport::TestCase
      def setup
        @users_index_route = find_route("users", "index")
        @projects_show_route = find_route("projects", "show")
      end

      def test_build_returns_an_oas_route_object
        users_index_oas_route = OasRouteBuilder.build_from_rails_route(@users_index_route)
        assert_instance_of ::OasCore::OasRoute, users_index_oas_route
      end

      def test_build_sets_correct_controller
        users_index_oas_route = OasRouteBuilder.build_from_rails_route(@users_index_route)
        assert_equal "users", users_index_oas_route.controller
      end

      def test_build_sets_correct_method
        users_index_oas_route = OasRouteBuilder.build_from_rails_route(@users_index_route)
        assert_equal "index", users_index_oas_route.method_name
      end

      def test_build_sets_correct_verb
        users_index_oas_route = OasRouteBuilder.build_from_rails_route(@users_index_route)
        assert_equal "GET", users_index_oas_route.verb
      end

      def test_build_sets_correct_path
        users_index_oas_route = OasRouteBuilder.build_from_rails_route(@users_index_route)
        assert_equal "/users", users_index_oas_route.path
      end

      def test_build_sets_correct_docstring
        users_index_oas_route = OasRouteBuilder.build_from_rails_route(@users_index_route)
        assert_not_nil users_index_oas_route.docstring
      end

      def test_build_sets_correct_source_string
        users_index_oas_route = OasRouteBuilder.build_from_rails_route(@users_index_route)
        assert_not_nil users_index_oas_route.source_string
      end

      def test_build_sets_correct_tags
        users_index_oas_route = OasRouteBuilder.build_from_rails_route(@projects_show_route)
        assert_not_nil users_index_oas_route.tags
        assert(users_index_oas_route.tags.all? { |tag| tag.respond_to?(:tag_name) })
      end
    end
  end
end
