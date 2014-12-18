class AddStation < Ellington::Station

  def engage(wrapped_number)
    wrapped_number.result = wrapped_number.first_subtract + wrapped_number.second_reverse
    wrapped_number.result == 1089
  end

end
