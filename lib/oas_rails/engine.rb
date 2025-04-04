module OasRails
  class Engine < ::Rails::Engine
    isolate_namespace OasRails
    config.to_prepare do
      ActiveSupport::Inflector.inflections(:en) do |inflect|
        inflect.acronym 'YARD'
      end
    end

    config.app_middleware.use(
      Rack::Static,
      urls: ["/oas-rails-assets"],
      root: OasRails::Engine.root.join("public")
    )
  end
end
