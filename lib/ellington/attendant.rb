module Ellington

  # The agent responsible for ensuring that passengers behave at stations.
  # More specifically, the Attendant ensures that a passenger's state
  # only transitions once per station.
  class Attendant
    attr_reader :passenger_transitions

    def initialize(passenger)
      @passenger_transitions = []
    end

    def update(passenger, old_state, new_state)
      passenger_transitions << TransitionInfo.new(passenger, old_state, new_state)
    end

    def approve?
      @passenger_transitions.length <= 1
    end

  end
end
