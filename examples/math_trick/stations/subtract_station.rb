module MathTrick
  class SubtractStation < Ellington::Station
    transitions_passenger_to :step2_pass, :step2_fail, :step2_error

    def engage(passenger, options={})
      begin
        options[:first_subtract] = passenger.context - options[:first_reverse]
        passenger.transition_to(:step2_pass)
      rescue Exception
        passenger.transition_to(:step2_error)
      end
    end
  end
end
