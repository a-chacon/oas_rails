require "test_helper"

module OasRails
  module Builders
    class ResponsesBuilderTest < Minitest::Test
      def setup
        @specification = Spec::Specification.new
      end

      # def test_add_autodiscover_responses
      #   oas_route = build_oas_route({
      #                                 source_string: <<~RUBY
      #                                   def create
      #                                     @post = Post.new(post_params)
      #                                     if @post.save
      #                                       render json: @post, status: :created
      #                                     else
      #                                       render json: @post.errors, status: :unprocessable_entity
      #                                     end
      #                                   end
      #                                 RUBY
      #                               })
      #
      #   OasRails.config.autodiscover_responses = true
      #   @responses = ResponsesBuilder.new(@specification).add_autodiscovered_responses(oas_route).build
      #
      #   assert @responses.responses.any?
      # end
      #
      # def test_not_add_autodiscover_responses
      #   OasRails.config.autodiscover_responses = false
      #   @responses = ResponsesBuilder.new(@specification).add_autodiscovered_responses(@oas_route_login).build
      #
      #   assert @responses.responses.empty?
      # end
      #
      # def test_add_default_responses_with_security
      #   OasRails.config.set_default_responses = true
      #   @responses = ResponsesBuilder.new(@specification).add_default_responses(@oas_route_create, true).build
      #
      #   assert_includes @responses.responses.keys, 401 # unauthorized
      #   assert_includes @responses.responses.keys, 403 # forbidden
      #   assert_includes @responses.responses.keys, 500 # internal_server_error
      # end
      #
      # def test_add_default_responses_for_create_action
      #   OasRails.config.set_default_responses = true
      #   @responses = ResponsesBuilder.new(@specification).add_default_responses(@oas_route_create, false).build
      #
      #   assert_includes @responses.responses.keys, 422 # unprocessable_entity
      #   refute_includes @responses.responses.keys, 401 # unauthorized (security false)
      # end
      #
      # def test_add_default_responses_for_update_action
      #   OasRails.config.set_default_responses = true
      #   @responses = ResponsesBuilder.new(@specification).add_default_responses(@oas_route_update, true).build
      #
      #   assert_includes @responses.responses.keys, 404 # not_found
      #   assert_includes @responses.responses.keys, 422 # unprocessable_entity
      #   assert_includes @responses.responses.keys, 401 # unauthorized (security true)
      # end
      #
      # def test_not_add_default_responses_when_disabled
      #   OasRails.config.set_default_responses = false
      #   @responses = ResponsesBuilder.new(@specification).add_default_responses(@oas_route_login, true).build
      #
      #   assert_empty @responses.responses
      # end
      #
      # def test_not_add_autodiscovered_responses_when_are_documented_responses
      #   OasRails.config.autodiscover_responses = true
      #   @responses = ResponsesBuilder.new(@specification).add_autodiscovered_responses(@oas_route_show).build
      #
      #   assert @responses.responses.empty?
      # end
    end
  end
end
