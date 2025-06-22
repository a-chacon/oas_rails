# frozen_string_literal: true

# Manage Users Here
#
# @response_example Another 405 Error (405)
#   [JSON
#   {
#     "message": "another",
#     "data": {
#       "availabilities": [
#         "three"
#       ],
#       "dates": []
#     }
#   }
#   ]
class UsersController < ApplicationController
  before_action :authorize!, except: [:create, :login]
  before_action :set_user, only: %i[show update destroy]

  # @summary Login
  # @request_body_ref #/components/requestBodies/LoginRequest
  # @no_auth
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token:, exp: time.strftime("%m-%d-%Y %H:%M"),
                     username: @user.name }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # Returns a list of Users.
  #
  # Status can be -1(Deleted), 0(Inactive), 1(Active), 2(Expired) and 3(Cancelled).
  #
  #
  # @parameter offset(query) [Integer]  Used for pagination of response data (default: 25 items per response). Specifies the offset of the next block of data to receive.
  # @parameter status(query) [!String]   Filter by status. (e.g. status=inactive).
  # @parameter stages(query) [Array<String>]   Filter by stages. (e.g. status=inactive).
  # @parameter_ref #/components/parameters/userId
  # @response Users list(200) [Array<User>]
  def index
    @users = User.all

    render json: @users
  end

  # @summary Get a user by id.
  #
  # This method show a User by ID. The id must exist of other way it will be returning a 404.
  # @parameter id(path) [!Integer] Used for identify the user.
  # @response A nice user(200) [Reference:#/components/schemas/User]
  # @response_ref (201) #/components/responses/UserResponse
  # @response User not found by the provided Id(404) [Hash{success: Boolean, message: String}]
  # @response You dont have the rigth persmissions for access to this reasource(403) [Hash{success: Boolean, message: String}]
  # @response A test response from an Issue(405)
  #   [
  #     Hash{
  #       message: String,
  #       data: Hash{
  #         availabilities: Array<String>,
  #         dates: Array<Date>
  #       }
  #     }
  #   ]
  #
  # @response_example Nice 405 Error(405)
  #   [JSON{ "message": "Hello", "data": { "availabilities": ["one", "two", "three"], "dates": ["10-06-2020"]}}]
  def show
    render json: @user
  end

  # @summary Create a User New
  # @no_auth
  # @tags 1. First
  #
  # To act as connected accounts, clients can issue requests using the Stripe-Account special header. Make sure that this header contains a Stripe account ID, which usually starts with the acct_ prefix.
  # The value is set per-request as shown in the adjacent code sample. Methods on the returned object reuse the same account ID.ased on the strings
  #
  # @request_body The user to be created. At least include an `email`. [!User]
  # @request_body_example basic user
  #   [JSON
  #   {
  #     "user": {
  #       "name": "Oas",
  #       "email": "oas@test.com",
  #       "password": "Test12345"
  #     }
  #   }
  #   ]
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { success: false, errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # Update a user.
  # @tags 2. Second
  # A `user` can be updated with this method
  # - There is no option
  # - It must work
  # @request_body User to be created [Reference:#/components/schemas/User]
  # @request_body_example Update user [Reference:#/components/examples/UserExample]
  # @request_body_example Complete User [JSON{"user": {"name": "Luis", "email": "luis@gmail.com", "age": 21}}]
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # @oas_include
  def destroy
    @user.destroy!
    redirect_to users_url, notice: 'User was successfully destroyed.', status: :see_other
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def login_params
    params.permit(:email, :password)
  end
end
