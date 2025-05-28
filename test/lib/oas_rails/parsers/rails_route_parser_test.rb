require "test_helper"

module OasRails
  module Parsers
    class RailsRouteParserTest < Minitest::Test
      def setup
        @route = find_route("users", "index")
        @parser = OasRails::Parsers::RailsRouteParser.new(@route)
      end

      def test_build
        oas_route = @parser.build

        assert_equal "UsersController", oas_route.controller_class
        assert_equal "UsersController#index", oas_route.controller_action
        assert_equal "users", oas_route.controller
        assert_equal "index", oas_route.method
        assert_equal "GET", oas_route.verb
        assert_equal "/users", oas_route.path
        assert oas_route.docstring.is_a?(::YARD::Docstring)
        assert oas_route.source_string.is_a?(String)
        assert oas_route.tags.is_a?(Array)
      end

      def test_controller_class
        assert_equal "UsersController", @parser.send(:controller_class)
      end

      def test_controller_action
        assert_equal "UsersController#index", @parser.send(:controller_action)
      end

      def test_controller
        assert_equal "users", @parser.send(:controller)
      end

      def test_method
        assert_equal "index", @parser.send(:method)
      end

      def test_verb
        assert_equal "GET", @parser.send(:verb)
      end

      def test_path
        assert_equal "/users", @parser.send(:path)
      end

      def test_source_string
        assert_match(/def index/, @parser.send(:source_string))
      end

      def test_docstring
        docstring = @parser.send(:docstring)
        assert docstring.is_a?(::YARD::Docstring)
        assert_match(/This endpoint list users/, docstring.to_s)
      end

      def test_tags
        tags = @parser.send(:tags)
        assert tags.is_a?(Array)
        assert(tags.any? { |tag| tag.tag_name == "auth" })
      end

      private

      def find_route(controller_name, action_name)
        Rails.application.routes.routes.find do |route|
          defaults = route.defaults
          defaults[:controller] == controller_name && defaults[:action] == action_name
        end
      end
    end
  end
end
