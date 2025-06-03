class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_one_attached :avatar

  validate :valid_avatar

  def valid_avatar
    return unless avatar.attached?

    errors.add(:avatar, 'size must be less than 5MB') if avatar.blob.byte_size > 5.megabytes

    return if avatar.content_type.in?(%w[image/jpeg image/png image/gif image/svg+xml image/webp])

    errors.add(:avatar, 'must be a JPEG, PNG, GIF, SVG or WEBP image')
  end
end
