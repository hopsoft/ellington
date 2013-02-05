module MathTrick
  class FirstReverseStation < Ellington::Station
    transitions_passenger_to :first_reverse_pass, :first_reverse_fail, :first_reverse_error

    def engage(passenger, options={})
      begin
        options[:first_reverse] = passenger.context.to_s.reverse.to_i
        passenger.transition_to(:first_reverse_pass)
      rescue Exception
        passenger.transition_to(:first_reverse_error)
      end
    end
  end
end
