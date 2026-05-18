class Admin::ReportsController < ApplicationController
  # @summary Administrative reports and counts
  # @tags Admin
  # @response Report(200) [Hash{ posts_count: Integer, comments_count: Integer, recent_posts: Array<String> }]
  def index
    render json: {
      posts_count: Post.count,
      comments_count: Comment.count,
      recent_posts: Post.order(created_at: :desc).limit(5).pluck(:id, :title)
    }
  end
end
