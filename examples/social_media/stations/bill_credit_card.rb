class BillCreditCard < Ellington::Station

  def engage(user)
    # TODO: Charge the credit card on file for the user.
    MockStationHelper.new(self).mock_engage(user)
  end

end
