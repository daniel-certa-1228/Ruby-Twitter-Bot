require 'twitter'
require 'pg'
require_relative 'lyrics'

begin

  lyrics = Lyrics.class_variable_get(:@@lyricHash)
  keys = lyrics.keys
  #The counter keeping track of which line to tweet is stored on a pgsql database
  uri = URI.parse(ENV['DATABASE_URL'])
  c = PG.connect( uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password )
  db_num = c.exec( "SELECT counter FROM counter;").getvalue 0,0
  count = db_num.to_i #The current count

  tweet = lyrics[keys[count]] #defines the tweet as the value that is at the index number of the count

  client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
        config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
        config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
        config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
    end
    
  client.update(tweet) #sends the tweet

  count += 1 #increment the counter

  if count == lyrics.length #if the count equals the length of the hash, it needs to be reset to zero to start at the beginning
    c.exec( "UPDATE counter SET counter = 0;")
  else #else we store the new number in the database
    c.exec( "UPDATE counter SET counter = #{count};")
  end
  
rescue PG::Error => e
  puts e.message
ensure
  c.close if c #close the db connection
end
