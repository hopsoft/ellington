class MathTrick < Ellington::Route
  lines << TrickWith1089.new
  goal lines.last.passed
  set_passenger_attrs_to_log :value, :first_reverse, :first_subtract, :second_reverse, :result
end

