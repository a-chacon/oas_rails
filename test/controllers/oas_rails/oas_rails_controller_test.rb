require 'test_helper'

module OasRails
  class OasRailsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'should return public docs' do
      get '/api/docs'
      assert_response :ok
    end

    test 'should return public oas docs' do
      get '/api/docs.json'
      assert_response :ok
    end

    test 'should return internal docs' do
      get '/internal/api/docs'
      assert_response :ok
    end

    test 'should return internal oas docs' do
      get '/internal/api/docs.json'
      assert_response :ok
    end
  end
end
