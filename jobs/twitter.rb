require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = "Uq7p4UUllnsvf2HGSzGIYLhzg"
  config.consumer_secret     = "DKbvNfBJZOIE5yqNPCYGIHYqgTtfcmwCTGH1gyw84UEvHW8WBD"
  config.access_token        = "910851327386890241-gkCiNqcjtoBbE2EgQm9ua6dTOB65w1s"
  config.access_token_secret = "iQvRh1NKU8JAsrbJ5BncKwS18aWbf4B2QfVvXfVOGE5wz"
end

search_term = URI::encode('#dramco')

SCHEDULER.every '1m', :first_in => 0 do |job|
  begin
    tweets = twitter.search("#{search_term}")

    if tweets
      tweets = tweets.map do |tweet|
        { name: tweet.user.name, body: tweet.text, time: tweet.created_at }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end
