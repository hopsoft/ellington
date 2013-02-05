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
        states.add :new_number => [:step1_pass, :step1_fail, :step1_error]
        states.add :step1_fail
        states.add :step1_error
        states.add :step1_pass => [:step2_pass, :step2_fail, :step2_error]
        states.add :step2_fail
        states.add :step2_error
        states.add :step2_pass => [:step3_pass, :step3_fail, :step3_error]
        states.add :step3_fail
        states.add :step3_error
        states.add :step3_pass => [:step4_pass, :step4_fail, :step4_error]
        states.add :step4_fail
        states.add :step4_error
        states.add :step4_pass
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
        goal = Ellington::Goal.new(:step4_pass)
        ticket = Ellington::Ticket.new(goal)
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
