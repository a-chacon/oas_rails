require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @project = projects(:one)
  end

  test "should get index" do
    get user_projects_url(@user), as: :json
    assert_response :success
  end

  test "should create project" do
    assert_difference("Project.count") do
      post user_projects_url(@user), params: { project: { description: "new project", name: "new_project", user_id: @user.id } }, as: :json
    end

    assert_response :created
  end

  test "should show project" do
    get project_url(@project), as: :json
    assert_response :success
  end

  test "should update project" do
    patch project_url(@project), params: { project: { description: @project.description, name: @project.name, user_id: @project.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy project" do
    assert_difference("Project.count", -1) do
      delete project_url(@project), as: :json
    end

    assert_response :no_content
  end
end
