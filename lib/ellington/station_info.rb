module Ellington
  class StationInfo
    attr_reader :station, :passenger, :transition, :options
    def initialize(station, passenger, transition, options)
      @station = station
      @passenger = passenger
      @transition = transition
      @options = options
    end
  end
end
