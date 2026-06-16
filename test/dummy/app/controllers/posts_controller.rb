class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  # @summary List posts
  # @tags Posts
  # @response Posts list(200) [Array<Post>]
  def index
    @posts = Post.all
    render json: @posts
  end

  # @summary Show a post by id
  # @tags Posts
  # @parameter id(path) [!Integer] The post ID
  # @response A post(200) [Reference:#/components/schemas/Post]
  # @response Post not found(404) [Hash{message: String}]
  def show
    render json: @post
  end

  # @summary Create a new post
  # @tags Posts
  # @request_body Post to create [Reference:#/components/schemas/Post]
  # @response Post created(201) [Reference:#/components/schemas/Post]
  def create
    @post = Post.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # @summary Update a post
  # @tags Posts
  # @parameter id(path) [!Integer] The post ID
  # @request_body Post to update [Reference:#/components/schemas/Post]
  # @response Updated post(200) [Reference:#/components/schemas/Post]
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # @summary Delete a post
  # @tags Posts
  # @parameter id(path) [!Integer] The post ID
  # @response No content(204) []
  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :published)
  end
end
