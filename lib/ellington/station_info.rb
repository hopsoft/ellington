module Ellington
  class StationInfo
    attr_reader :station, :passenger, :transition
    def initialize(station, passenger, transition)
      @station = station
      @passenger = passenger
      @transition = transition
    end
  end
end
