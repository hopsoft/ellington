class BillCreditCard < Ellington::Station

  def engage(user, options)
    begin
      # TODO: Charge the credit card on file for the user.

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
