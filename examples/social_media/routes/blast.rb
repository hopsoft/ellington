class Blast < Ellington::Route

  facebook = lines.add(Facebook.new) # entry line since its the first added
  twitter  = lines.add(Twitter.new)
  billing  = lines.add(Billing.new)

  connect twitter, after: [facebook.passed, facebook.failed, facebook.errored]
  connect billing, after: [facebook.passed, twitter.passed], strict: true

  goal billing.passed

  # extra attributes we want to log
  # these exist on the user
  set_passenger_attrs_to_log :id, :current_message
end
