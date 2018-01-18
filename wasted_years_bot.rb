require 'Twitter'
require_relative 'lyrics'

lyrics = Lyrics.class_variable_get(:@@lyricHash)
keys = lyrics.keys
file = File.open('counter.txt', 'r+')
count = file.read.to_i
tweet = lyrics[keys[count]]

client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
      config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
      config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
      config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
  end
  
client.update(tweet)

count += 1

file.rewind

if count == lyrics.length
  file.write('0 ')
else
  file.write(count)
end

file.close
