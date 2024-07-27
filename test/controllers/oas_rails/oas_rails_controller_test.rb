require 'test_helper'

module OasRails
  class OasRailsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'should return the oas' do
      get '/docs/oas'
      assert_response :ok
    end
  end
end
