class CanTweet < Ellington::Station

  def engage(user, options)
    begin
      # TODO: Apply business rules to determine if a tweet can be sent.
      # For example, only allow 1 tweet every 15 minutes.

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
