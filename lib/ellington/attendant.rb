module Ellington
  class Attendant
    attr_reader :passenger_transitions

    def initialize(passenger)
      @passenger_transitions = []
    end

    def update(passenger, old_state, new_state)
      passenger_transitions << TransitionInfo.new(passenger, old_state, new_state)
    end

    def approves?
      @passenger_transitions.length <= 1
    end

  end
end
