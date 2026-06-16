class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:destroy]

  # @summary Create a comment for a post
  # @tags Comments
  # @parameter post_id(path) [!Integer] The post ID
  # @request_body Comment to create [Hash{ body: String, user: String }]
  # @response Comment created(201) [Reference:#/components/schemas/Comment]
  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # @summary Delete a comment
  # @tags Comments
  # @parameter post_id(path) [!Integer] The post ID
  # @parameter id(path) [!Integer] The comment ID
  # @response No content(204) [Hash{body: String}]
  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :user)
  end
end
