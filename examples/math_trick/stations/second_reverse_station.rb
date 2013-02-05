module MathTrick
  class SecondReverseStation < Ellington::Station
    transitions_passenger_to :step3_pass, :step3_fail, :step3_error

    def engage(passenger, options={})
      begin
        options[:second_reverse] = options[:first_subtract].to_s.reverse.to_i
        passenger.transition_to(:step3_pass)
      rescue Exception
        passenger.transition_to(:step3_error)
      end
    end
  end
end
