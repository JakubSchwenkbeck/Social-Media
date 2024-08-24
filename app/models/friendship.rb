class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum status: { pending: 0, accepted: 1 }

  validates :user_id, uniqueness: { scope: :friend_id }
  validate :not_self

  def not_self
    errors.add(:friend, "can't be equal to user") if user == friend
  end
end
