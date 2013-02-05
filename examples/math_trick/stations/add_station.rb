module MathTrick
  class AddStation < Ellington::Station
    transitions_passenger_to :add_pass, :add_fail, :add_error

    def engage(passenger, options={})
      begin
        result = options[:first_subtract] + options[:second_reverse]
        if result == 1089
          passenger.transition_to(:add_pass)
        else
          passenger.transition_to(:add_fail)
        end
      rescue Exception
        passenger.transition_to(:add_error)
      end
    end
  end
end
