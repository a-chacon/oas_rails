# frozen_string_literal: true

module AuthHelper
  def assign_token(user_id)
    token = JsonWebToken.encode(user_id:)
    default_headers['Authorization'] = "Bearer #{token}"
  end

  def default_headers
    @default_headers ||= {}
  end
end
