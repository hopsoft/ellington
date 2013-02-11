require "forwardable"

module Ellington
  class Line
    extend Forwardable
    attr_accessor :route
    def_delegators :"self.class", :stations

    def board(passenger)
      formula.run passenger
    end

    def full_name
      @full_name ||= "#{self.class.name} > #{route.name}"
    end

    def formula
      @formula ||= begin
        Hero::Formula[full_name]
        Hero::Formula[full_name].steps.clear
        stations.each do |station|
          Hero::Formula[full_name].add_step station
        end
        Hero::Formula[full_name]
      end
    end

    #def states
    #  @states ||= begin
    #    states = StateJacket::Catalog.new
    #    self.class.stations.each_with_index do |station, index|
    #      full_name = "[#{station.class.name}][#{self.class.name}][#{route.name}]"
    #      pass = :"[PASS]#{full_name}"
    #      fail = :"[FAIL]#{full_name}"
    #      error = :"[ERROR]#{full_name}"
    #      states.add error => [pass, fail, error]
    #      states.add fail

    #      if index + 1 < self.class.stations.length
    #        next_station = self.class.stations[index + 1]
    #        next_full_name = "[#{next_station.class.name}][#{self.class.name}][#{route.name}]"
    #        next_pass = :"[PASS]#{next_full_name}"
    #        next_fail = :"[FAIL]#{next_full_name}"
    #        next_error = :"[ERROR]#{next_full_name}"
    #        states.add pass => [next_pass, next_fail, next_error]
    #      else
    #        states.add pass
    #      end
    #    end
    #    states
    #  end
    #end

    class << self

      def stations
        @stations ||= Ellington::StationCollection.new(self)
      end

      def goal(*stations)
        @goal = stations
      end

      def connections(connections)
        @connections = connections
      end
    end

  end
end
