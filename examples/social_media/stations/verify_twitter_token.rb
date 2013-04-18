class VerifyTwitterToken < Ellington::Station

  def engage(user, options)
    # TODO: Verify the OAuth token for the user's Twitter account.
    MockStationHelper.new(self).mock_engage(user, options)
  end

end
