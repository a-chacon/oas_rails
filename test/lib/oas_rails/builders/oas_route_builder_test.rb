require 'test_helper'

module OasRails
  module Builders
    class OasRouteBuilderTest < ActiveSupport::TestCase
      def setup
        @users_index_route = find_route("users", "index")
        @users_create_route = find_route("users", "create")
        @projects_show_route = find_route("projects", "show")
        @typed_index_route = find_route("typed", "index")
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

      def test_docstring_blank_comment_lines_produce_paragraph_breaks
        oas_route = OasRouteBuilder.build_from_rails_route(@users_create_route)
        docstring_text = oas_route.docstring.to_s

        # The comment contains a bare `#` line between "Invite a user..." and
        # "To act as connected accounts...". With the old regex (/^# /) that
        # line was left as a literal "#" in the output. The fixed regex
        # (/^# ?/) strips it to an empty line, producing a proper paragraph.
        assert_includes docstring_text, "Invite a user to an organization."
        assert_includes docstring_text, "To act as connected accounts"
        refute_includes docstring_text, "#", "bare '#' must not appear in the parsed docstring"
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

      # Tests for Sorbet runtime-wrapper compatibility

      def test_wrapped_by_runtime_returns_false_for_unwrapped_method
        builder = OasRouteBuilder.new(@users_index_route)
        unbound = UsersController.instance_method(:index)
        refute builder.send(:wrapped_by_runtime?, unbound)
      end

      def test_wrapped_by_runtime_returns_true_for_sorbet_wrapped_method
        builder = OasRouteBuilder.new(@typed_index_route)
        unbound = TypedController.instance_method(:index)
        assert builder.send(:wrapped_by_runtime?, unbound)
      end

      def test_method_comment_safe_returns_annotations_for_unwrapped_method
        builder = OasRouteBuilder.new(@users_index_route)
        comment = builder.send(:method_comment_safe)
        assert_includes comment, "@parameter offset(query)"
        assert_includes comment, "@response Users list"
      end

      def test_method_comment_safe_returns_annotations_for_sorbet_wrapped_method
        builder = OasRouteBuilder.new(@typed_index_route)
        comment = builder.send(:method_comment_safe)
        assert_includes comment, "@summary List typed items"
        assert_includes comment, "@response Typed items list"
      end

      def test_class_comment_safe_returns_class_annotations_for_sorbet_wrapped_method
        builder = OasRouteBuilder.new(@typed_index_route)
        comment = builder.send(:class_comment_safe)
        assert_includes comment, "@tags Typed"
        assert_includes comment, "Typed Items API"
      end

      def test_build_works_for_sorbet_wrapped_controller
        oas_route = OasRouteBuilder.build_from_rails_route(@typed_index_route)
        assert_instance_of ::OasCore::OasRoute, oas_route
        assert_equal "typed", oas_route.controller
        assert_equal "index", oas_route.method_name
        assert_equal "GET", oas_route.verb

        summary_tags = oas_route.tags.select { |t| t.tag_name == "summary" }
        assert_equal 1, summary_tags.size
        assert_equal "List typed items", summary_tags.first.text
      end
    end
  end
end
