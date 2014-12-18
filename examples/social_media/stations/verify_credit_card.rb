class VerifyCreditCard < Ellington::Station

  def engage(user)
    # TODO: Verify the credit card on file for the user.
    MockStationHelper.new(self).mock_engage(user)
  end

end
