class ShouldTweet < Ellington::Station

  def engage(user, options)
    begin
      # TODO: Apply business rules to determine if a tweet should be sent.
      # For example, no tweets about Justin Beiber should ever be made if the user is over 13.

      raise if rand(100) == 0
      ok = rand(100) > 5

      if ok
        pass_passenger user
      else
        fail_passenger user
      end
    rescue
      error_passenger user
    end
  end

end
