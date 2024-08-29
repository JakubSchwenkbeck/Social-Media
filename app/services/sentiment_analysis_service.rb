# app/services/sentiment_analysis_service.rb
require 'textblob'

class SentimentAnalysisService
  def initialize(text)
    @text = text
  end

  def analyze
    blob = TextBlob.new(@text)
    {
      sentiment: blob.sentiment[:polarity],
      subjectivity: blob.sentiment[:subjectivity]
    }
  end
end
