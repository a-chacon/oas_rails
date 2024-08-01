module OasRails
  class OasRailsController < ApplicationController
    layout false

    def index
      respond_to do |format|
        format.html
        format.json do
          render json: Specification.new.to_json, status: :ok
        end
      end
    end
  end
end
