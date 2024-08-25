class User < ApplicationRecord
  # Devise modules for user authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Attachment for profile picture using ActiveStorage
  has_one_attached :profile_picture

  has_many :posts, dependent: :destroy


  # Friendships where the user is the initiator
  has_many :sent_friendships, class_name: 'Friendship', foreign_key: 'user_id', dependent: :destroy
  # Friendships where the user is the recipient
  has_many :received_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy

  # Friends where the user is the initiator of the friendship
  has_many :sent_friends, -> { where(friendships: { status: 'accepted' }) }, through: :sent_friendships, source: :friend
  # Friends where the user is the recipient of the friendship
  has_many :received_friends, -> { where(friendships: { status: 'accepted' }) }, through: :received_friendships, source: :user

  # Combine both to get all friends
  def friends
    sent_friends + received_friends
  end

  # Pending friend requests sent by the user
  has_many :pending_sent_requests, -> { where(friendships: { status: 'pending' }) }, through: :sent_friendships, source: :friend
  # Pending friend requests received by the user
  has_many :pending_received_requests, -> { where(friendships: { status: 'pending' }) }, through: :received_friendships, source: :user

  # Send a friend request
  def send_friend_request(friend)
    sent_friendships.create(friend: friend, status: 'pending')
  end

  # Accept a friend request
  def accept_friend_request(user)
    friendship = received_friendships.find_by(user: user)
    friendship.update(status: 'accepted') if friendship
  end

  # Remove a friend (removes the friendship relationship entirely)
  def remove_friend(friend)
    sent_friendship = sent_friendships.find_by(friend: friend)
    received_friendship = received_friendships.find_by(user: friend)
    sent_friendship.destroy if sent_friendship
    received_friendship.destroy if received_friendship
  end

  # Check if already friends
  def friends_with?(user)
    friends.include?(user)
  end

  # Check if a friend request was sent to this user
  def sent_request_to?(user)
    pending_sent_requests.include?(user)
  end

  # Check if a pending request is from this user
  def pending_request_from?(user)
    pending_received_requests.include?(user)
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
