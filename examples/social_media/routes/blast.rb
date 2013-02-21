class Blast < Ellington::Route

  facebook = Facebook.new
  twitter = Twitter.new
  billing = Billing.new

  lines << facebook # entry line since its the first added
  lines << twitter
  lines << billing

  connect_to twitter, :if_currently => [facebook.passed, facebook.failed, facebook.errored]
  connect_to billing, :if_ever => [facebook.passed, twitter.passed]

  goal billing.passed

  # extra attributes we want to log
  # these exist on the user
  log_passenger_attrs :id, :current_message
end
