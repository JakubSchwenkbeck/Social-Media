class User < ApplicationRecord
  # Devise modules and other validations
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
