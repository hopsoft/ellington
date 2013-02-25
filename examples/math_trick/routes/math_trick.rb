class MathTrick < Ellington::Route
  lines << TrickWith1089.new
  goal lines.last.passed
  log_passenger_attrs :to_s
end

