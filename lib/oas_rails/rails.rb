module OasRails
  class Engine < ::Rails::Engine
    isolate_namespace OasRails

    # Configure autoload paths for Rails-specific files
    config.autoload_paths << File.expand_path("rails/controllers", __dir__)
    config.autoload_paths << File.expand_path("rails/helpers", __dir__)

    # Set views directory
    paths["app/views"] = File.expand_path("rails/views", __dir__)

    # Routes
    routes.draw do
      get "/oas_rails", to: "oas_rails#index", as: :oas_rails
    end

    # Inflections and middleware
    config.to_prepare do
      ActiveSupport::Inflector.inflections(:en) do |inflect|
        inflect.acronym 'YARD'
      end
    end
  end
end
