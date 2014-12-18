class ShouldTweet < Ellington::Station

  def engage(user)
    # TODO: Apply business rules to determine if a tweet should be sent.
    # For example, no tweets about Justin Beiber should ever be made if the user is over 13.
    MockStationHelper.new(self).mock_engage(user)
  end

end
