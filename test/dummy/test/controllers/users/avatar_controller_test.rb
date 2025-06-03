require "test_helper"

module Users
  class AvatarControllerTest < ActionDispatch::IntegrationTest
    include AuthHelper

    setup do
      @user = users(:one)
    end

    test "should require authentication" do
      patch user_avatar_url(@user), params: { avatar: fixture_file_upload('avatar.jpg', 'image/jpeg') }, headers: default_headers
      assert_response :unauthorized
      assert_not @user.avatar.attached?
    end

    test "should update avatar" do
      assign_token(@user.id)
      patch user_avatar_url(@user), params: { avatar: fixture_file_upload('avatar.jpg', 'image/jpeg') }, headers: default_headers
      assert_response :ok
      assert_equal 'Avatar uploaded successfully', json_response['message']
      assert @user.avatar.attached?
    end

    test "should not update avatar with invalid file" do
      assign_token(@user.id)
      patch user_avatar_url(@user), params: { avatar: fixture_file_upload('plain_text.txt', 'text/plain') }, headers: default_headers
      assert_response :unprocessable_entity
      assert_not @user.avatar.attached?
    end

    private

    def json_response
      JSON.parse(response.body)
    end
  end
end
