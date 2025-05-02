require 'test_helper'

module OasRails
  class OasRouteTest < ActiveSupport::TestCase
    test 'initializes with attributes' do
      attributes = {
        controller_class: 'UsersController',
        controller_action: 'index',
        rails_route: find_route("users", "index")
      }

      route = OasRoute.new(attributes)
      assert_equal 'UsersController', route.controller_class
      assert_equal 'index', route.controller_action
      assert_kind_of ActionDispatch::Journey::Route, route.rails_route
    end

    test 'extracts path parameters' do
      route = OasRoute.new(
        rails_route: find_route("users", "show")
      )
      assert_equal ['id'], route.path_params
    end

    test 'ignores format parameter' do
      route = OasRoute.new(
        rails_route: find_route("users", "show")
      )
      assert_equal ['id'], route.path_params
    end

    test 'filters tags by name' do
      tags = [
        Struct.new(:tag_name).new('admin'),
        Struct.new(:tag_name).new('public')
      ]
      route = OasRoute.new(tags: tags)
      assert_equal 1, route.tags('admin').size
      assert_equal 'admin', route.tags('admin').first.tag_name
    end

    test 'returns all tags when no name is provided' do
      tags = [
        Struct.new(:tag_name).new('admin'),
        Struct.new(:tag_name).new('public')
      ]
      route = OasRoute.new(tags: tags)
      assert_equal 2, route.tags.size
    end
  end
end
