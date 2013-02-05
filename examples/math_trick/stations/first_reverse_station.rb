module MathTrick
  class FirstReverseStation < Ellington::Station
    transitions_passenger_to :step1_pass, :step1_fail, :step1_error

    def engage(passenger, options={})
      begin
        options[:first_reverse] = passenger.context.to_s.reverse.to_i
        passenger.transition_to(:step1_pass)
      rescue Exception
        passenger.transition_to(:step1_error)
      end
    end
  end
end
