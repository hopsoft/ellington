module Ellington

  class Attendant
    attr_reader :station, :passenger_transitions

    def initialize(station)
      @station = station
      @passenger_transitions = []
    end

    def update(transition_info)
      passenger_transitions << transition_info
    end

    def approve?
      passenger_transitions.length == 1 && 
        station.states.include?(passenger_transitions.first.new_state)
    end

  end
end
