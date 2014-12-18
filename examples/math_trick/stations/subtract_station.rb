class SubtractStation < Ellington::Station

  def engage(wrapped_number)
    wrapped_number.first_subtract = wrapped_number.value - wrapped_number.first_reverse
  end

end
