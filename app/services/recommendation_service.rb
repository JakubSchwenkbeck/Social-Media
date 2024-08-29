# app/services/recommendation_service.rb
require 'daru'
require 'matrix'

class RecommendationService
  def initialize(user_data, item_data)
    @user_data = user_data
    @item_data = item_data
  end

  def recommend(user_id)
    user_preferences = @user_data[user_id]
    recommendations = []

    @item_data.each do |item_id, item_features|
      similarity = calculate_similarity(user_preferences, item_features)
      recommendations << { item_id: item_id, similarity: similarity }
    end

    recommendations.sort_by { |r| -r[:similarity] }.take(10) # Top 10 recommendations
  end

  private

  def calculate_similarity(user_preferences, item_features)
    user_vector = Daru::Vector.new(user_preferences)
    item_vector = Daru::Vector.new(item_features)

    dot_product = user_vector.dot(item_vector)
    magnitude_user = Math.sqrt(user_vector.dot(user_vector))
    magnitude_item = Math.sqrt(item_vector.dot(item_vector))

    return 0 if magnitude_user.zero? || magnitude_item.zero?

    dot_product / (magnitude_user * magnitude_item)
  end
end
