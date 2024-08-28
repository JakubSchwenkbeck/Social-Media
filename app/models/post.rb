class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :collaborators, class_name: 'User', join_table: 'collaborations'

  validate :content_required_for_post_type

  serialize :mood_tags, Array # Enables storing an array of strings

  def content_required_for_post_type
    if post_type.present? && %w[standard storytelling].include?(post_type) && content.blank?
      errors.add(:content, "can't be blank")
    end
  end

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

  # Join mood_tags for display purposes
  def mood_tags_list
    mood_tags.join(', ')
  end
end
