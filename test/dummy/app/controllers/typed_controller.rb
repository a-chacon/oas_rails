# frozen_string_literal: true

require "sorbet-runtime"

# Typed Items API
#
# @tags Typed
class TypedController < ApplicationController
  extend T::Sig

  # @summary List typed items
  # @response Typed items list(200) [Array<String>]
  sig { void }
  def index
    render json: { items: [] }
  end

  # @summary Show a typed item
  # @parameter id(path) [!Integer] The item ID
  sig { void }
  def show
    render json: { item: params[:id] }
  end
end
