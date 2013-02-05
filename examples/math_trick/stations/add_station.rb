module MathTrick
  class AddStation < Ellington::Station
    transitions_passenger_to :step4_pass, :step4_fail, :step4_error

    def engage(passenger, options={})
      begin
        result = options[:first_subtract] + options[:second_reverse]
        if result == 1089
          passenger.transition_to(:step4_pass)
        else
          passenger.transition_to(:step4_fail)
        end
      rescue Exception
        passenger.transition_to(:step4_error)
      end
    end
  end
end
