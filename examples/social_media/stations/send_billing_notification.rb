class SendBillingNotification < Ellington::Station

  def engage(user, options)
    # TODO: Send billing info to the user.
    MockStationHelper.new(self).mock_engage(user, options)
  end

end
