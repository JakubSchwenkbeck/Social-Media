# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# Create predefined mood tags with mostly positive vibes
moods = [
  'Happy',          # General happiness
  'Excited',        # High energy, anticipation
  'Chill',          # Relaxed, laid-back
  'Comfy',          # Cozy, comfortable
  'Fun',            # Enjoyable, playful
  'Heartwarming',   # Emotionally touching
  'Energetic',      # Full of energy
  'Inspiring',      # Motivating, uplifting
  'Joyful',         # Pure joy
  'Peaceful',       # Calm and serene
  'Optimistic',     # Positive outlook
  'Playful',        # Light-hearted, fun
  'Motivated',      # Driven, enthusiastic
  'Refreshing',     # New and invigorating
  'Grateful',       # Thankful, appreciative
  'Bright',         # Lively and positive
  'Comforting'      # Reassuring and soothing
]

moods.each do |mood|
  MoodTag.create(name: mood)
end
