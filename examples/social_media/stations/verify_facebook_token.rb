class VerifyFacebookToken < Ellington::Station

  def engage(user)
    # TODO: Verify the OAuth token for the user's Facebook account.
    MockStationHelper.new(self).mock_engage(user)
  end

end
