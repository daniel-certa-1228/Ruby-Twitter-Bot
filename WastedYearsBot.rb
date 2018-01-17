require 'Twitter'
require_relative 'lyrics'
require 'active_support/time'

def tweetRock
  lyrics = Lyrics.class_variable_get(:@@lyricHash)
  lyrics.each do |key, val|
    client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
        config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
        config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
        config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
      end
      t = Time.now
      tweet = val
      # client.update(tweet)
      puts tweet
      sleep (t + 1.second - Time.now)
  end
end

tweetRock
