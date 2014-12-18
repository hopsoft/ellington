class SendBillingNotification < Ellington::Station

  def engage(user)
    # TODO: Send billing info to the user.
    MockStationHelper.new(self).mock_engage(user)
  end

end
