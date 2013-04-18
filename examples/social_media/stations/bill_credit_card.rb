class BillCreditCard < Ellington::Station

  def engage(user, options)
    # TODO: Charge the credit card on file for the user.
    MockStationHelper.new(self).mock_engage(user, options)
  end

end
