require "hero"

module Ellington
  class Line
    attr_reader :name, :route

    def initialize(name)
      @name = name
    end

    def route=(value)
      raise Ellington::RouteAlreadyAssigned unless @route.nil?
      @route = value
    end

    def add_station(station)
      station.line = self
      Hero::Formula[name].add_step station.name, station
    end

    def stations
      Hero::Formula[name].steps.map(&:last)
    end

  end
end
