require "minitest/autorun"
require "minitest/mock"
require 'minitest/reporters'
require "oas_rails"

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
  when :sinatra
    require 'rack/test'
    require_relative '../dummy/sinatra_app/app'
  else
    raise ArgumentError, "Unsupported framework: #{framework}"
  end
end
