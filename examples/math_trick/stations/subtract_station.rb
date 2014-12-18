class SubtractStation < Ellington::Station

  def engage(wrapped_number)
    begin
      wrapped_number.first_subtract = wrapped_number.value - wrapped_number.first_reverse
      pass_passenger wrapped_number
    rescue
      error_passenger wrapped_number
    end
  end

end
