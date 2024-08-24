class Post < ApplicationRecord
  # Establish a relationship indicating that each post belongs to a single user.
  # This creates an association where each post record is linked to one user record.
  belongs_to :user

  # Validate that the content of the post is present (i.e., not blank).
  # This ensures that a post cannot be saved without some content.
  validates :content, presence: true
  
  # Validate that the title of the post is present (i.e., not blank).
  # This ensures that a post must have a title to be saved.
  validates :title, presence: true

  # Add attachment handling for an image. This allows posts to have an attached image file.
  # Uses ActiveStorage to manage file uploads and attachments.
  has_one_attached :image
end
