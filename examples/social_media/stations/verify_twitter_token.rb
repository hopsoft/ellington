class VerifyTwitterToken < Ellington::Station

  def engage(user)
    # TODO: Verify the OAuth token for the user's Twitter account.
    MockStationHelper.new(self).mock_engage(user)
  end

end
