class VerifyFacebookToken < Ellington::Station

  def engage(user, options)
    begin
      # TODO: Verify the OAuth token for the user's Facebook account.

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
