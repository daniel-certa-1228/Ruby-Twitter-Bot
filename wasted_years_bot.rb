require 'twitter'
require 'pg'
require_relative 'lyrics'

begin

  lyrics = Lyrics.class_variable_get(:@@lyricHash)
  keys = lyrics.keys
  c = PG.connect( dbname: 'wy_counter')
  db_num = c.exec( "SELECT counter FROM counter;").getvalue 0,0
  count = db_num.to_i

  tweet = lyrics[keys[count]]

  client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
        config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
        config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
        config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
    end
    
  client.update(tweet)

  count += 1

  if count == lyrics.length
    c.exec( "UPDATE counter SET counter = 0;")  
  else
    c.exec( "UPDATE counter SET counter = #{count};")
  end

  puts count

rescue PG::Error => e
  puts e.message
ensure
  c.close if c
end
