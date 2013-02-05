module MathTrick
  class SecondReverseStation < Ellington::Station
    transitions_passenger_to :second_reverse_pass, :second_reverse_fail, :second_reverse_error

    def engage(passenger, options={})
      begin
        options[:second_reverse] = options[:first_subtract].to_s.reverse.to_i
        passenger.transition_to(:second_reverse_pass)
      rescue Exception
        passenger.transition_to(:second_reverse_error)
      end
    end
  end
end
