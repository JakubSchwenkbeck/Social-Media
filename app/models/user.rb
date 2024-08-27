class User < ApplicationRecord
  before_save :check_for_sql_injection

  # Devise modules for user authentication
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Attachment for profile picture using ActiveStorage
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  has_one_attached :profile_picture
  has_many :posts, dependent: :destroy

  has_and_belongs_to_many :collaborated_posts, class_name: 'Post', join_table: 'collaborations'


    # Friendships where the user is either the initiator or the recipient
    has_many :friendships, dependent: :destroy
  
    # Users who are friends with this user
    has_many :friends, -> { where(friendships: { status: 'accepted' }) }, through: :friendships
  
    # Friendships where the user sent the request
    has_many :pending_sent_requests, -> { where(friendships: { status: 'pending' }) }, class_name: 'Friendship', foreign_key: 'user_id'
    
    # Friendships where the user received the request
    has_many :pending_received_requests, -> { where(friendships: { status: 'pending' }) }, class_name: 'Friendship', foreign_key: 'friend_id'
  
    # Send a friend request
    def send_friend_request(friend)
      unless friends_with?(friend) || sent_request_to?(friend) || pending_request_from?(friend)
        friendships.create(friend: friend, status: 'pending')
      end
    end
  
    # Accept a friend request
    def accept_friend_request(user)
      friendship = pending_received_requests.find_by(user: user)
      friendship.update(status: 'accepted') if friendship
    end
  
    # Remove a friend (removes the friendship relationship entirely)
    def remove_friend(friend)
      friendship = friendships.find_by(friend: friend) || friendships.find_by(user: friend)
      friendship&.destroy
    end
  
    # Check if already friends
    def friends_with?(user)
      friends.include?(user)
    end
  
    # Check if a friend request was sent to this user
    def sent_request_to?(user)
      pending_sent_requests.exists?(friend: user)
    end
  
    # Check if a pending request is from this user
    def pending_request_from?(user)
      pending_received_requests.exists?(user: user)
    end
  

  # Custom validation for profile picture
  validate :acceptable_image

  private
  def check_for_sql_injection
    fields_to_check = [email, username, biography]
    fields_to_check.each do |field|
      if SqlInjectionDetection::Checker.check(field)
        errors.add(:base, "Invalid input detected. Please avoid using potentially harmful SQL statements.")
        throw :abort
      end
    end
  end
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
