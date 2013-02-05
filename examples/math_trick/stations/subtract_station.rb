module MathTrick
  class SubtractStation < Ellington::Station
    transitions_passenger_to :subtract_pass, :subtract_fail, :subtract_error

    def engage(passenger, options={})
      begin
        options[:first_subtract] = passenger.context - options[:first_reverse]
        passenger.transition_to(:subtract_pass)
      rescue Exception
        passenger.transition_to(:subtract_error)
      end
    end
  end
end
