# Examples

```ruby
class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  # @summary Returns a list of Users.
  #
  # @parameter offset(query) [Integer]  Used for pagination of response data (default: 25 items per response). Specifies the offset of the next block of data to receive.
  # @parameter status(query) [Array<String>]   Filter by status. (e.g. status[]=inactive&status[]=deleted).
  # @parameter X-front(header) [String] Header for identify the front.
  def index
    @users = User.all
  end

  # @summary Get a user by id.
  # @auth [bearer]
  #
  # This method show a User by ID. The id must exist of other way it will be returning a **`404`**.
  #
  # @parameter id(path) [Integer] Used for identify the user.
  # @response Requested User(200) [Hash] {user: {name: String, email: String, created_at: DateTime }}
  # @response User not found by the provided Id(404) [Hash] {success: Boolean, message: String}
  # @response You don't have the right permission for access to this resource(403) [Hash] {success: Boolean, message: String}
  def show
    render json: @user
  end

  # @summary Create a User
  # @no_auth
  #
  # @request_body The user to be created. At least include an `email`. [!User]
  # @request_body_example basic user [Hash] {user: {name: "Luis", email: "luis@gmail.ocom"}}
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: { success: false, errors: @user.errors }, status: :unprocessable_entity
    end
  end

  # A `user` can be updated with this method
  # - There is no option
  # - It must work
  # @tags users, update
  # @request_body User to be created [!Hash{user: { name: String, email: !String, age: Integer, available_dates: Array<Date>}}]
  # @request_body_example Update user [Hash] {user: {name: "Luis", email: "luis@gmail.com"}}
  # @request_body_example Complete User [Hash] {user: {name: "Luis", email: "luis@gmail.com", age: 21}}
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # @summary Delete a User
  # Delete a user and his associated data.
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
    params.require(:user).permit(:name, :email)
  end
end
```


