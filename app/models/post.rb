class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :collaborators, class_name: 'User', join_table: 'collaborations'

  validates :content, presence: true
  validates :title, presence: true

  has_one_attached :image

  def add_collaborator(user)
    collaborators << user unless collaborators.include?(user)
  end

  def remove_collaborator(user)
    collaborators.delete(user)
  end
end
