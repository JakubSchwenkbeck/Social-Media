class User < ApplicationRecord
  # Devise modules to handle user authentication:
  # - :database_authenticatable: Allows authentication using a database.
  # - :registerable: Provides registration functionality.
  # - :recoverable: Allows password recovery.
  # - :rememberable: Manages generating and clearing token for remembering the user from a saved cookie.
  # - :validatable: Provides basic validation for email and password.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Add attachment handling for a profile picture. This allows users to have one profile picture attached.
  # Uses ActiveStorage for managing file uploads.
  has_one_attached :profile_picture

  # Establish a one-to-many relationship where a user can have multiple posts.
  # If a user is deleted, all associated posts will also be deleted.
  has_many :posts, dependent: :destroy

  # Validate that the username is present and unique (case-insensitive).
  # Ensures that no two users have the same username.
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # Validate the biography length and ensure it does not exceed 500 characters.
  # Allow blank biographies.
  validates :biography, length: { maximum: 500 }, allow_blank: true


 # Friendships
 has_many :sent_friendships, class_name: 'Friendship', foreign_key: 'user_id', dependent: :destroy
 has_many :received_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy

 # Friends (accepted)
 has_many :friends, -> { where(friendships: { status: :accepted }) }, through: :sent_friendships, source: :friend

 # Pending friend requests sent by the user
 has_many :pending_sent_requests, -> { where(friendships: { status: :pending }) }, through: :sent_friendships, source: :friend

 # Pending friend requests received by the user
 has_many :pending_received_requests, -> { where(friendships: { status: :pending }) }, through: :received_friendships, source: :user

 # Define enum for friendship status
 enum friendship_status: { pending: 0, accepted: 1 }

 # Methods for friend management
 def send_friend_request(friend)
   sent_friendships.create(friend: friend, status: :pending)
 end

 def accept_friend_request(user)
   received_friendships.find_by(user: user)&.update(status: :accepted)
 end

 def remove_friend(friend)
   friends.destroy(friend)
 end

 def friends_with?(user)
   friends.include?(user)
 end

 def sent_request_to?(user)
   sent_friend_requests.include?(user)
 end

 def pending_request_from?(user)
   pending_received_requests.include?(user)
 end

  # Custom validation for the profile picture.
  # Ensures the attached image is no larger than 1 megabyte and is either JPEG or PNG.
  def acceptable_image
    return unless profile_picture.attached?

    # Validate the size of the attached image.
    unless profile_picture.byte_size <= 1.megabyte
      errors.add(:profile_picture, "is too big")
    end

    # Validate the content type of the attached image.
    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(profile_picture.content_type)
      errors.add(:profile_picture, "must be a JPEG or PNG")
    end
  end
end
