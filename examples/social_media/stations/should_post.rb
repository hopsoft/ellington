class ShouldPost < Ellington::Station

  def engage(user, options)
    begin
      # TODO: Apply business rules to determine if a Facebook post should be sent.
      # For example, no posts about Justin Beiber should ever be made if the user is over 13.

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
