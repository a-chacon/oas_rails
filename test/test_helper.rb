# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"
require "minitest/mock"
require_relative "helpers/auth_helper"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [File.expand_path("fixtures", __dir__), File.expand_path("../test/dummy/test/fixtures", __dir__)]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
  ActiveSupport::TestCase.fixtures :all
end

# Helper method to find a Rails route by controller and action
def find_route(controller_name, action_name)
  Rails.application.routes.routes.find do |route|
    defaults = route.defaults
    defaults[:controller] == controller_name && defaults[:action] == action_name
  end
end

def find_oas_route(controller_name, action_name)
  OasRails::Builders::OasRouteBuilder.build_from_rails_route(find_route(controller_name, action_name))
end
