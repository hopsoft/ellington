module Ellington
  class Attendant
    attr_reader :line, :passenger_transitions

    def initialize(line)
      @line = line
      @passenger_transitions = []
    end

    def verify?(station, passenger)
      passenger_transitions.clear
      # TODO: implement
      false
    end

    TransitionInfo = Struct.new(:passenger, :old_state, :new_state)

    def update(passenger, old_state, new_state)
      passenger_transitions << TransitionInfo.new(passenger, old_state, new_state)
    end

  end
end
