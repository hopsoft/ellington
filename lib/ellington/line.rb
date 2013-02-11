require "forwardable"

module Ellington
  class Line
    extend Forwardable
    attr_accessor :route
    def_delegators :"self.class", :stations

    def board(passenger)
      self.class.board passenger
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
      attr_reader :formula

      def inherited(subclass)
        @formula = Hero::Formula[self.class.name]
        formula.steps.clear
      end

      def board(passenger)
        formula.run passenger
      end

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
