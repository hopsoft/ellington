module Ellington

  class Attendant
    attr_reader :passenger_transitions

    def initialize
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
