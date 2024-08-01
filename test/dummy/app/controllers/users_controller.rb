# frozen_string_literal: true

# Manage Users Here
class UsersController < ApplicationController
  before_action :authorize!, except: [:create, :login]
  before_action :set_user, only: %i[show update destroy]

  # @summary Login
  # @request_body Valid Login Params [Hash!] { email: String, password: String}
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
  # @parameter status(query) [String!]   Filter by status. (e.g. status=inactive).
  # @parameter stages(query) [Array<String>]   Filter by stages. (e.g. status=inactive).
  # @parameter X-Page(header) [String] Header for identify
  def index
    @users = User.all
  end

  # @summary Get a user by id.
  #
  # This method show a User by ID. The id must exist of other way it will be returning a 404.
  # @parameter id(path) [Integer] Used for identify the user.
  # @response A nice user(200) [Hash] {user: {name: String, email: String, created_at: DateTime }}
  # @response User not found by the provided Id(404) [Hash] {success: Boolean, message: String}
  # @response You dont have the rigth persmissions for access to this reasource(403) [Hash] {success: Boolean, message: String}
  def show
    render json: @user
  end

  # @summary Create a User New
  # @no_auth
  #
  # To act as connected accounts, clients can issue requests using the Stripe-Account special header. Make sure that this header contains a Stripe account ID, which usually starts with the acct_ prefix.
  # The value is set per-request as shown in the adjacent code sample. Methods on the returned object reuse the same account ID.ased on the strings
  #
  # @request_body The user to be created. At least include an `email`. [User!]
  # @request_body_example basic user [Hash] {user: {name: "Luis", email: "luis@gmail.ocom"}}
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { success: false, errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # Update a user.
  # A `user` can be updated with this method
  # - There is no option
  # - It must work
  # @request_body User to be created [Hash] {user: { name: String, email: String, age: Integer}}
  # @request_body_example Update user [Hash] {user: {name: "Luis", email: "luis@gmail.com"}}
  # @request_body_example Complete User [Hash] {user: {name: "Luis", email: "luis@gmail.com", age: 21}}
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
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
