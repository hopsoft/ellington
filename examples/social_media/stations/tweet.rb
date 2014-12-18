class Tweet < Ellington::Station

  def engage(user)
    # TODO: Send a tweet on behalf of the user.
    MockStationHelper.new(self).mock_engage(user)
  end

end
