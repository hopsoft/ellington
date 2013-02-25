class MathTrick < Ellington::Route
  lines << TrickWith1089.new
  goal lines.last.passed
  log_options :passenger => [:to_s], 
    :options => [:first_reverse, :first_subtract, :second_reverse, :result]
end

