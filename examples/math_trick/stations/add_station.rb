class AddStation < Ellington::Station

  def engage(wrapped_number)
    begin
      wrapped_number.result = wrapped_number.first_subtract + wrapped_number.second_reverse
      if wrapped_number.result == 1089
        pass_passenger wrapped_number
      else
        fail_passenger wrapped_number
      end
    rescue
      error_passenger wrapped_number
    end
  end

end
