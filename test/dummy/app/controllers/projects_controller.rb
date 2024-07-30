# Management of `Projects` happend here.
class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show update destroy]

  # @tags projects
  def index
    @projects = Project.all

    render json: @projects
  end

  def show
    render json: @project
  end

  # @tags projects
  def create
    @project = Project.new(project_params)

    if @project.save
      render json: @project, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    params.require(:project).permit(:name, :description, :user_id)
  end
end
