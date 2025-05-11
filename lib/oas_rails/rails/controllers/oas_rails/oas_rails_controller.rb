module OasRails
  class OasRailsController < ApplicationController
    # Include URL help if the layout is a user-customized layout.
    include Rails.application.routes.url_helpers

    def index
      respond_to do |format|
        format.html { render "index", layout: OasRails.config.layout }
        format.json do
          render json: OasRails.build.to_json, status: :ok
        end
      end
    end
  end
end
