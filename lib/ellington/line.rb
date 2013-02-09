module Ellington
  class Line
    attr_accessor :route

    def board(passenger)
      self.class.board passenger
    end

    def states
      @states ||= begin
        states = StateJacket::Catalog.new
        self.class.stations.each_with_index do |station, index|
          full_name = "[#{station.class.name}][#{self.class.name}][#{route.name}]"
          pass = :"[PASS]#{full_name}"
          fail = :"[FAIL]#{full_name}"
          error = :"[ERROR]#{full_name}"
          states.add error => [pass, fail, error]
          states.add pass
          states.add fail
        end
        states
      end
    end

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
