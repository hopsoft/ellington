class Blast < Ellington::Route

  facebook = lines.add(Facebook.new) # entry line since its the first added
  twitter = lines.add(Twitter.new)
  billing = lines.add(Billing.new)

  connect_to twitter, :if_any => [facebook.passed, facebook.failed, facebook.errored]
  connect_to billing, :if_all => [facebook.passed, twitter.passed]

  goal billing.passed

  # extra attributes we want to log
  # these exist on the user
  set_passenger_attrs_to_log :id, :current_message
end
