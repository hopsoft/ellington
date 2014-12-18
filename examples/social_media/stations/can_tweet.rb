class CanTweet < Ellington::Station

  def engage(user)
    # TODO: Apply business rules to determine if a tweet can be sent.
    # For example, only allow 1 tweet every 15 minutes.
    MockStationHelper.new(self).mock_engage(user)
  end

end
