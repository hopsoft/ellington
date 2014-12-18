class Post < Ellington::Station

  def engage(user)
    # TODO: Make a Facebook post on behalf of the user.
    MockStationHelper.new(self).mock_engage(user)
  end

end
