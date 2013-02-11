require "forwardable"

module Ellington
  class Line
    extend Forwardable
    attr_accessor :route
    def_delegators :"self.class", :stations, :goal

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

    def states
      @states ||= begin
        states = StateJacket::Catalog.new
        stations.each_with_index do |station, index|
          states.merge! station.states
          if index < stations.length - 1
            next_station = stations[index + 1]
            states[station.state_name(:pass)] = next_station.states.keys
          end
        end
        states
      end
    end

    def fault
      states.keys - goal
    end

    class << self

      def stations
        @stations ||= Ellington::StationList.new(self)
      end

      def goal(*states)
        @goal ||= states
      end

      def connections
        @connections ||= {}
      end

    end

  end
end
