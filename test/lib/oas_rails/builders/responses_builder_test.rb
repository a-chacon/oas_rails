module OasRails
  module Builders
    class ResponsesBuilderTest < Minitest::Test
      def setup
        @specification = Spec::Specification.new
        @oas_route = OasRoute.new_from_rails_route(rails_route: Rails.application.routes.routes.find { |a| a.name == "users_login" })
      end

      def test_add_autodiscover_responses
        OasRails.config.autodiscover_responses = true
        @responses = ResponsesBuilder.new(@specification).add_autodiscovered_responses(@oas_route).build

        assert @responses.responses.any?
      end

      def test_not_add_autodiscover_responses
        OasRails.config.autodiscover_responses = false
        @responses = ResponsesBuilder.new(@specification).add_autodiscovered_responses(@oas_route).build

        assert @responses.responses.empty?
      end

      def test_add_default_responses
        OasRails.config.set_default_responses = true
        @responses = ResponsesBuilder.new(@specification).add_default_responses(@oas_route, true).build

        assert @responses.responses.any?
      end

      def test_not_add_default_responses
        OasRails.config.set_default_responses = false
        @responses = ResponsesBuilder.new(@specification).add_default_responses(@oas_route, false).build

        assert @responses.responses.empty?
      end
    end
  end
end
