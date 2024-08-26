class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :collaborators, class_name: 'User', join_table: 'collaborations'

  validates :content, presence: true
  validates :title, presence: true
  validates :post_type, inclusion: { in: %w[standard storytelling gallery] }

  has_one_attached :image
  has_many_attached :images # For gallery posts

  def add_collaborator(user)
    collaborators << user unless collaborators.include?(user)
  end

  def remove_collaborator(user)
    collaborators.delete(user)
  end

  def standard_post?
    post_type == 'standard'
  end

  def storytelling_post?
    post_type == 'storytelling'
  end

  def gallery_post?
    post_type == 'gallery'
  end
end
