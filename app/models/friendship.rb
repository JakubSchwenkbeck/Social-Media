class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum status: { pending: 0, accepted: 1 }

  validates :user_id, uniqueness: { scope: :friend_id, message: "Friendship already exists" }

  # Ensure symmetrical friendships
  after_create :create_inverse, unless: :inverse_exists?
  after_destroy :destroy_inverse, if: :inverse_exists?

  def create_inverse
    self.class.create(user: friend, friend: user, status: status)
  end

  def destroy_inverse
    inverse&.destroy
  end

  def inverse
    self.class.find_by(user: friend, friend: user)
  end

  def inverse_exists?
    self.class.exists?(user: friend, friend: user)
  end
end
