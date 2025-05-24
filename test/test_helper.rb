$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "oas_rails"

require "minitest/autorun"
require "minitest/mock"
require 'minitest/reporters'
require "debug"

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

# Helper method to find a Rails route by controller and action
def find_route(controller_name, action_name)
  # Rails.application.routes.routes.find do |route|
  #   defaults = route.defaults
  #   defaults[:controller] == controller_name && defaults[:action] == action_name
  # end
end

def find_oas_route(controller_name, action_name)
  OasRails::Builders::OasRouteBuilder.build_from_rails_route(find_route(controller_name, action_name))
end

# Required for run Rails test
def load_dummy(framework)
  case framework
  when :rails
    ENV["RAILS_ENV"] ||= "test"
    require_relative "../test/dummy/rails_app/config/environment"
    require "rails/test_help"

    # require specific Rails Clases
    $LOAD_PATH.unshift File.expand_path("../lib", __dir__)
    require "oas_rails/parsers/rails_route_parser"
    require "oas_rails/extractors/rails_route_extractor"
  when :sinatra
    require 'rack/test'
    require_relative '../dummy/sinatra_app/app'
  else
    raise ArgumentError, "Unsupported framework: #{framework}"
  end
end

def generate_yard_comment
  <<~YARD
    # This endpoint creates a User
    #
    # @auth [bearer, basic]
    # @parameter page(query) [Integer] The page number.
    # @request_body The user to be created [Hash{ user: Hash{ name: String, age: Integer, password: String}]
    # @request_body_example A complete User. [Hash] {user: {name: 'Luis', age: 30, password: 'MyWeakPassword123'}}
    # @response User not found by the provided Id(404) [Hash{success: Boolean, message: String}]
    # @response_example Invalid Email(422) [Hash{success: "false", errors: Array<Hash{field: "email", type: "email"}>}]
    # @tags Users, Admin
  YARD
end

def parse_yard_comment(comment)
  lines = comment.lines.map { |line| line.sub(/^# /, '') }
  YARD::Docstring.parser.parse(lines.join).tags
end

def build_oas_route(attributes = {})
  comment = generate_yard_comment
  tags = parse_yard_comment(comment)

  defaults = {
    controller_class: "DummyController",
    controller_action: "DummyController#index",
    controller: "dummy",
    method: "index",
    verb: "GET",
    path: "/dummy",
    docstring: "DocString",
    source_string: "def index; end",
    tags: tags

  }
  OasRails::OasRoute.new(defaults.merge(attributes))
end
