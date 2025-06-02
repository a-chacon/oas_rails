# frozen_string_literal: true

class Users::AvatarController < ApplicationController
  before_action :authorize!
  before_action :set_user

  # @summary Upload an avatar
  # @tags 3. Third
  #
  # Uploads an avatar for the user. The avatar must be a valid image file (image/jpg, image/png, image/gif and etc).
  # @request_body Avatar Image. Accepted formats:  (multipart/form-data) [!Hash{avatar: !File}]
  # @request_body_example Test Avatar [Hash] {avatar: 'path/to/avatar.jpg'}
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