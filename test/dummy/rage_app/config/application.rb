require "bundler/setup"
require "rage"

# $LOAD_PATH.unshift File.expand_path("../../../../lib", __dir__)
# require "oas_rails"

require "rage/all"

Rage.configure do
  # use this to add settings that are constant across all environments
end

require "rage/setup"
