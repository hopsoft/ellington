# A script to load all dependencies.

require_relative "../../lib/ellington"

%w(stations lines routes).each do |dir|
  $:.unshift File.join(File.dirname(__FILE__), dir)
end

%w{
  bill_credit_card
  can_post
  can_tweet
  post
  send_billing_notification
  should_post
  should_tweet
  tweet
  verify_credit_card
  verify_facebook_token
  verify_twitter_token
  facebook
  twitter
  billing
  blast
}.each { |file| require file }

require_relative "blast_observer"
require_relative "user"
