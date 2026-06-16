module OasRails
  class OasRailsController < ApplicationController
    # Include URL help if the layout is a user-customized layout.
    include Rails.application.routes.url_helpers

    before_action :resolve_config

    def index
      respond_to do |format|
        format.html { render "index", layout: @config.layout }
        format.json do
          render json: OasRails.build(config: @config).to_json, status: :ok
        end
      end
    end

    private

    def resolve_config
      config_name = params.dig("default", "configuration")&.to_sym || :default
      @config = OasRails.config(config_name)
    end
  end
end
