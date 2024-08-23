class Post < ApplicationRecord
  belongs_to :user

  validates :content, presence: true
  validates :title, presence: true

    # Adding attachment handling
    has_one_attached :image
end
