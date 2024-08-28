class Post < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :collaborators, class_name: 'User', join_table: 'collaborations'

  validate :content_required_for_post_type

  before_save :serialize_mood_tags
  after_find :deserialize_mood_tags

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

  def mood_tags
    # Deserialize JSON string into an array
    JSON.parse(read_attribute(:mood_tags) || "[]")
  rescue JSON::ParserError
    []
  end

  def mood_tags=(value)
    # Serialize array into JSON string
    write_attribute(:mood_tags, value.to_json)
  end

  private

  def serialize_mood_tags
    self.mood_tags = mood_tags
  end

  def deserialize_mood_tags
    self.mood_tags = mood_tags
  end
end