# frozen_string_literal: true

module Users
  class AvatarController < ApplicationController
    before_action :authorize!
    before_action :set_user

    # @summary Upload an avatar
    # @tags 3. Third
    #
    # Uploads an avatar for the user. The avatar must be a valid image file (JPEG, PNG, GIF, SVG or WEBP).
    # @request_body Avatar Image (multipart/form-data) [!Hash{avatar: !File}]
    # @request_body_example Test Avatar [JSON{ "avatar": 'path/to/avatar.jpg'}]
    # @response Avatar uploaded successfully(200) [Hash{success: Boolean, message: String}]
    def update
      if @user.avatar.attach(avatar_params)
        render json: { success: true, message: 'Avatar uploaded successfully' }, status: :ok
      else
        render json: { success: false, errors: @user.errors }, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.find(params[:user_id])
    end

    def avatar_params
      params.require(:avatar)
    end
  end
end
