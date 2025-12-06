module OasRails
  class Engine < ::Rails::Engine
    isolate_namespace OasRails

    config.assets_prefix = "/oas-rails-assets"

    config.app_middleware.use(
      Rack::Static,
      urls: [config.assets_prefix],
      root: OasRails::Engine.root.join("public")
    )
  end
end
