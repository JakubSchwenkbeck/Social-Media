class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_picture

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # You might want to add validations for the profile picture, e.g.:
  validate :acceptable_image

  def acceptable_image
    return unless profile_picture.attached?

    unless profile_picture.byte_size <= 1.megabyte
      errors.add(:profile_picture, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(profile_picture.content_type)
      errors.add(:profile_picture, "must be a JPEG or PNG")
    end
  end
end
