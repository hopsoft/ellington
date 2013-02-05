module MathTrick
  class Conductor < Ellington::Conductor

    # some numbers to run through the math trick
    def numbers
      @numbers ||= [
        631,
        531,
        955,
        123 # will fail
      ]
    end

    def states
      @states ||= begin
        states = StateJacket::Catalog.new
        states.add :new_number => [:first_reverse_pass, :first_reverse_fail, :first_reverse_error]
        states.add :first_reverse_fail
        states.add :first_reverse_error
        states.add :first_reverse_pass => [:subtract_pass, :subtract_fail, :subtract_error]
        states.add :subtract_fail
        states.add :subtract_error
        states.add :subtract_pass => [:second_reverse_pass, :second_reverse_fail, :second_reverse_error]
        states.add :second_reverse_fail
        states.add :second_reverse_error
        states.add :second_reverse_pass => [:add_pass, :add_fail, :add_error]
        states.add :add_fail
        states.add :add_error
        states.add :add_pass
        states
      end
    end

    def verify(passenger)
      true
    end

    def gather_passengers
      num = numbers.pop
      puts num
      if num
        ticket = Ellington::Ticket.new(Ellington::Goal.new(:add_pass))
        passenger = Ellington::Passenger.new(num, ticket, states)
        passenger.current_state = :new_number
        return [passenger]
      else
        @stop = true
      end
      return []
    end

  end
end
