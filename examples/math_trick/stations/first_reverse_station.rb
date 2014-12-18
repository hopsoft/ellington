class FirstReverseStation < Ellington::Station

  def engage(wrapped_number)
    wrapped_number.first_reverse = wrapped_number.value.to_s.reverse.to_i
  end

end
