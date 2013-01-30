module Ellington

  # The agent responsible for ensuring that passengers behave at stations.
  # More specifically, the Attendant ensures that a passenger's state
  # only transitions once per station.
  class Attendant
    attr_reader :passenger_transitions

    def initialize(passenger)
      @passenger_transitions = []
    end

    def update(transition_info)
      passenger_transitions << transition_info
    end

    def approve?
      @passenger_transitions.length <= 1
    end

  end
end
