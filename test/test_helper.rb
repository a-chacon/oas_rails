require "minitest/autorun"
require "minitest/mock"
require 'minitest/reporters'
require "debug"

ENV["OAS_RAILS_ENV"] ||= "test"

ENV["RAILS_ENV"] ||= "test"
ENV["BACKTRACE"] ||= "test"
require_relative "../test/dummy/rails_app/config/environment"
require "rails/test_help"

ENV["RAGE_ENV"] ||= "test"

# Mock the root method of the Rage framework
module Rage
  def self.root
    Pathname.new(File.expand_path("../test/dummy/rage_app", __dir__))
  end
end

require_relative '../test/dummy/rage_app/config/environment'

# $LOAD_PATH.unshift File.expand_path("../lib", __dir__)
# require "oas_rails"

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

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
