module OasRails
  class Engine < ::Rails::Engine
    isolate_namespace OasRails

    # Middleware for static assets
    config.app_middleware.use(
      Rack::Static,
      urls: ["/oas-rails-assets"],
      root: File.expand_path("web/public", __dir__)
    )
  end
end
