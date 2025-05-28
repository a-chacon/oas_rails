class ProjectsController < RageController::API
  # @tags Projects
  # @summary List all projects
  # @response Projects list(200) [Array<Hash{id: Integer, title: String, description: String}>]
  # @response_example Projects list(200) [Array<Hash>]
  #   [
  #     { id: 1, title: "Project Alpha", description: "A sample project" },
  #     { id: 2, title: "Project Beta", description: "Another sample project" }
  #   ]
  def index
    projects = [
      { id: 1, title: "Project Alpha", description: "A sample project" },
      { id: 2, title: "Project Beta", description: "Another sample project" }
    ]
    render json: projects
  end

  # @tags Projects
  # @summary Get a specific project
  # @parameter id(path) [!Integer] The project ID
  # @response Project found(200) [Hash{id: Integer, title: String, description: String}]
  # @response Project not found(404) [Hash{error: String}]
  # @response_example Project found(200) [Hash]
  #   { id: 1, title: "Project Alpha", description: "A sample project" }
  # @response_example Project not found(404) [Hash]
  #   { error: "Project not found" }
  def show
    project = { id: params[:id].to_i, title: "Project Alpha", description: "A sample project" }
    if params[:id].to_i == 1
      render json: project
    else
      render json: { error: "Project not found" }, status: 404
    end
  end

  # @tags Projects
  # @summary Create a new project
  # @auth [bearer]
  # @request_body The project to be created [!Hash{title: String, description: String}]
  # @request_body_example Simple Project [Hash]
  #   {
  #     title: "New Project",
  #     description: "A new sample project"
  #   }
  # @response Project created(201) [Hash{id: Integer, title: String, description: String}]
  # @response Validation errors(422) [Hash{errors: Array<String>}]
  # @response_example Project created(201) [Hash]
  #   { id: 3, title: "New Project", description: "A new sample project" }
  # @response_example Validation errors(422) [Hash]
  #   { errors: ["Title is too short", "Description is required"] }
  def create
    project = { id: 3, title: params[:title], description: params[:description] }
    render json: project, status: 201
  end

  # @tags Projects
  # @summary Update a project
  # @auth [bearer]
  # @parameter id(path) [!Integer] The project ID
  # @request_body The project data to update [Hash{title: String, description: String}]
  # @request_body_example Updated Project [Hash]
  #   {
  #     title: "Updated Project",
  #     description: "Updated description"
  #   }
  # @response Project updated(200) [Hash{id: Integer, title: String, description: String}]
  # @response Project not found(404) [Hash{error: String}]
  # @response_example Project updated(200) [Hash]
  #   { id: 1, title: "Updated Project", description: "Updated description" }
  # @response_example Project not found(404) [Hash]
  #   { error: "Project not found" }
  def update
    if params[:id].to_i == 1
      project = { id: 1, title: params[:title], description: params[:description] }
      render json: project
    else
      render json: { error: "Project not found" }, status: 404
    end
  end

  # @tags Projects
  # @summary Delete a project
  # @auth [bearer]
  # @parameter id(path) [!Integer] The project ID
  # @response Project deleted(204) []
  # @response Project not found(404) [Hash{error: String}]
  # @response_example Project not found(404) [Hash]
  #   { error: "Project not found" }
  def destroy
    if params[:id].to_i == 1
      head :no_content
    else
      render json: { error: "Project not found" }, status: 404
    end
  end
end
