class SecondReverseStation < Ellington::Station

  def engage(wrapped_number)
    begin
      wrapped_number.second_reverse = wrapped_number.first_subtract.to_s.reverse.to_i
      pass_passenger wrapped_number
    rescue
      error_passenger wrapped_number
    end
  end

end
