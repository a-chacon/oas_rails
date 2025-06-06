require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include AuthHelper

  setup do
    @user = users(:one)
    assign_token(@user.id)
  end

  test "should get index" do
    get users_url, headers: default_headers
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email: "new_user@gmail.com", name: "new_user", password: "password" } }, headers: default_headers
    end

    assert_response :success
  end

  test "should show user" do
    get user_url(@user), headers: default_headers
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email: @user.email, name: @user.name } }, headers: default_headers
    assert_response :success
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user), headers: default_headers
    end

    assert_redirected_to users_url
  end
end
