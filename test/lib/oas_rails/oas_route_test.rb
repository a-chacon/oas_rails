require 'test_helper'

module OasRails
  class OasRouteTest < Minitest::Test
    def test_initializes_with_attributes
      attributes = {
        controller_class: 'UsersController',
        controller_action: 'index'
      }

      route = OasRoute.new(attributes)
      assert_equal 'UsersController', route.controller_class
      assert_equal 'index', route.controller_action
    end

    def test_filters_tags_by_name
      tags = [
        Struct.new(:tag_name).new('admin'),
        Struct.new(:tag_name).new('public')
      ]
      route = OasRails::OasRoute.new(tags: tags)
      assert_equal 1, route.tags('admin').size
      assert_equal 'admin', route.tags('admin').first.tag_name
    end

    def test_returns_all_tags_when_no_name_is_provided
      tags = [
        Struct.new(:tag_name).new('admin'),
        Struct.new(:tag_name).new('public')
      ]
      route = OasRails::OasRoute.new(tags: tags)
      assert_equal 2, route.tags.size
    end

    def test_extracts_path_params_correctly
      route = OasRails::OasRoute.new(path: '/users/:id/posts/:post_id.:format')
      assert_equal %w[id post_id], route.path_params
    end

    def test_excludes_format_from_path_params
      route = OasRails::OasRoute.new(path: '/users/:id.:format')
      assert_equal ['id'], route.path_params
    end

    def test_returns_empty_array_for_no_path_params
      route = OasRails::OasRoute.new(path: '/users')
      assert_nil route.path_params
    end

    def test_handles_empty_tags
      route = OasRails::OasRoute.new(tags: [])
      assert_empty route.tags
      assert_empty route.tags('admin')
    end
  end
end
