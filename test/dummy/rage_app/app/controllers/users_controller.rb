class UsersController < RageController::API
  # @tags Users
  # @summary List all users
  # @response Users list(200) [Array<Hash{id: Integer, name: String, email: String}>]
  # @response_example Users list(200) [Array<Hash>]
  #   [
  #     { id: 1, name: "John Doe", email: "john@example.com" },
  #     { id: 2, name: "Jane Smith", email: "jane@example.com" }
  #   ]
  def index
    users = [
      { id: 1, name: "John Doe", email: "john@example.com" },
      { id: 2, name: "Jane Smith", email: "jane@example.com" }
    ]
    render json: users
  end

  # @tags Users
  # @summary Get a specific user
  # @parameter id(path) [!Integer] The user ID
  # @response User found(200) [Hash{id: Integer, name: String, email: String}]
  # @response User not found(404) [Hash{error: String}]
  # @response_example User found(200) [Hash]
  #   { id: 1, name: "John Doe", email: "john@example.com" }
  # @response_example User not found(404) [Hash]
  #   { error: "User not found" }
  def show
    user = { id: params[:id].to_i, name: "John Doe", email: "john@example.com" }
    if params[:id].to_i == 1
      render json: user
    else
      render json: { error: "User not found" }, status: 404
    end
  end

  # @tags Users
  # @summary Create a new user
  # @auth [bearer]
  # @request_body The user to be created [!Hash{name: String, email: String, password: String}]
  # @request_body_example Simple User [Hash]
  #   {
  #     name: "New User",
  #     email: "new@example.com",
  #     password: "password123"
  #   }
  # @response User created(201) [Hash{id: Integer, name: String, email: String}]
  # @response Validation errors(422) [Hash{errors: Array<String>}]
  # @response_example User created(201) [Hash]
  #   { id: 3, name: "New User", email: "new@example.com" }
  # @response_example Validation errors(422) [Hash]
  #   { errors: ["Email is invalid", "Password is too short"] }
  def create
    user = { id: 3, name: params[:name], email: params[:email] }
    render json: user, status: 201
  end

  # @tags Users
  # @summary Update a user
  # @auth [bearer]
  # @parameter id(path) [!Integer] The user ID
  # @request_body The user data to update [Hash{name: String, email: String}]
  # @request_body_example Updated User [Hash]
  #   {
  #     name: "Updated Name",
  #     email: "updated@example.com"
  #   }
  # @response User updated(200) [Hash{id: Integer, name: String, email: String}]
  # @response User not found(404) [Hash{error: String}]
  # @response_example User updated(200) [Hash]
  #   { id: 1, name: "Updated Name", email: "updated@example.com" }
  # @response_example User not found(404) [Hash]
  #   { error: "User not found" }
  def update
    if params[:id].to_i == 1
      user = { id: 1, name: params[:name], email: params[:email] }
      render json: user
    else
      render json: { error: "User not found" }, status: 404
    end
  end

  # @tags Users
  # @summary Delete a user
  # @auth [bearer]
  # @parameter id(path) [!Integer] The user ID
  # @response User deleted(204) []
  # @response User not found(404) [Hash{error: String}]
  # @response_example User not found(404) [Hash]
  #   { error: "User not found" }
  def destroy
    if params[:id].to_i == 1
      head :no_content
    else
      render json: { error: "User not found" }, status: 404
    end
  end
end
