class User < ApplicationRecord
  # Devise modules for user authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Attachment for profile picture using ActiveStorage
  has_one_attached :profile_picture

  # Relationships
  has_many :posts, dependent: :destroy

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :biography, length: { maximum: 500 }, allow_blank: true

  # Friendships
  has_many :sent_friendships, class_name: 'Friendship', foreign_key: 'user_id', dependent: :destroy
  has_many :received_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy

  # Friends (accepted)
  has_many :friends, -> { where(friendships: { status: :accepted }) }, through: :sent_friendships, source: :friend

  # Pending friend requests
  has_many :pending_sent_requests, -> { where(friendships: { status: :pending }) }, through: :sent_friendships, source: :friend
  has_many :pending_received_requests, -> { where(friendships: { status: :pending }) }, through: :received_friendships, source: :user

  # Methods for friend management
  def send_friend_request(friend)
    sent_friendships.create(friend: friend, status: :pending)
  end

  def accept_friend_request(user)
    friendship = received_friendships.find_by(user: user)
    friendship.update(status: :accepted) if friendship
  end

  def remove_friend(friend)
    friends.destroy(friend)
  end

  def friends_with?(user)
    friends.include?(user)
  end

  def sent_request_to?(user)
    sent_friendships.where(friend: user, status: :pending).exists?
  end

  def pending_request_from?(user)
    received_friendships.where(user: user, status: :pending).exists?
  end

  # Custom validation for profile picture
  validate :acceptable_image

  private

  def acceptable_image
    return unless profile_picture.attached?

    if profile_picture.byte_size > 1.megabyte
      errors.add(:profile_picture, 'is too big (max size: 1 MB)')
    end

    unless ['image/jpeg', 'image/png'].include?(profile_picture.content_type)
      errors.add(:profile_picture, 'must be a JPEG or PNG')
    end
  end
end
