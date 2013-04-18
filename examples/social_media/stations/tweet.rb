class Tweet < Ellington::Station

  def engage(user, options)
    # TODO: Send a tweet on behalf of the user.
    MockStationHelper.new(self).mock_engage(user, options)
  end

end
