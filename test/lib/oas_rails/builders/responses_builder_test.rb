require "test_helper"

module OasRails
  module Builders
    class ResponsesBuilderTest < Minitest::Test
      def setup
        @specification = Spec::Specification.new
        @oas_route_login = OasRoute.new_from_rails_route(rails_route: Rails.application.routes.routes.find { |a| a.name == "users_login" })
        @oas_route_show = OasRoute.new_from_rails_route(rails_route: Rails.application.routes.routes.find { |a| a.name == "user" })
      end

      def test_add_autodiscover_responses
        OasRails.config.autodiscover_responses = true
        @responses = ResponsesBuilder.new(@specification).add_autodiscovered_responses(@oas_route_login).build

        assert @responses.responses.any?
      end

      def test_not_add_autodiscover_responses
        OasRails.config.autodiscover_responses = false
        @responses = ResponsesBuilder.new(@specification).add_autodiscovered_responses(@oas_route_login).build

        assert @responses.responses.empty?
      end

      def test_add_default_responses
        OasRails.config.set_default_responses = true
        @responses = ResponsesBuilder.new(@specification).add_default_responses(@oas_route_login, true).build

        assert @responses.responses.any?
      end

      def test_not_add_default_responses
        OasRails.config.set_default_responses = false
        @responses = ResponsesBuilder.new(@specification).add_default_responses(@oas_route_login, true).build

        assert @responses.responses.empty?
      end

      def test_not_add_autodiscovered_responses_when_are_documented_responses
        OasRails.config.autodiscover_responses = true
        @responses = ResponsesBuilder.new(@specification).add_autodiscovered_responses(@oas_route_show).build

        assert @responses.responses.empty?
      end
    end
  end
end
