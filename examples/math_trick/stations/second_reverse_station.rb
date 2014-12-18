class SecondReverseStation < Ellington::Station

  def engage(wrapped_number)
    wrapped_number.second_reverse = wrapped_number.first_subtract.to_s.reverse.to_i
  end

end
