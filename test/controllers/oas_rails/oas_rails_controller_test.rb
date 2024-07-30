require 'test_helper'

module OasRails
  class OasRailsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'should return the front' do
      get '/docs'
      assert_response :ok
    end

    test 'should return the oas' do
      get '/docs.json'
      assert_response :ok
    end
  end
end
