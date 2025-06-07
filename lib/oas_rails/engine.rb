module OasRails
  class Engine < ::Rails::Engine
    isolate_namespace OasRails

    config.app_middleware.use(
      Rack::Static,
      urls: ["/oas-rails-assets"],
      root: OasRails::Engine.root.join("public")
    )
  end
end
