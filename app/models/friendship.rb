class Friendship < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  # Enum for status
  enum status: { pending: 0, accepted: 1 }

  # Validations
  validates :user_id, uniqueness: { scope: :friend_id, message: "Friendship already exists" }
  validate :not_self

  # Custom validation
  def not_self
    errors.add(:friend, "can't be equal to user") if user == friend
  end

  # Scopes for querying friendships
  scope :pending_requests, -> { where(status: :pending) }
  scope :accepted_friends, -> { where(status: :accepted) }
end
