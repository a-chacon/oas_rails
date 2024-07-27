module OasRails
  class OasRailsController < ApplicationController
    def index; end

    def oas
      render json: Specification.new.to_json, status: :ok
    end
  end
end
