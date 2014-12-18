class ShouldPost < Ellington::Station

  def engage(user)
    # TODO: Apply business rules to determine if a Facebook post should be sent.
    # For example, no posts about Justin Beiber should ever be made if the user is over 13.
    MockStationHelper.new(self).mock_engage(user)
  end

end
