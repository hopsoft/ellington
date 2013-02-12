require "forwardable"
require "observer"

module Ellington
  class Line
    extend Forwardable
    include Observable
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
        catalog = StateJacket::Catalog.new
        stations.each_with_index do |station, index|
          catalog.merge! station.states
          if index < stations.length - 1
            next_station = stations[index + 1]
            catalog[station.state_name(:pass)] = next_station.states.keys
          end
        end
        catalog.lock
        catalog
      end
    end

    def fault
      @fault ||= (states.keys - goal).delete_if do |state|
        state.to_s =~ /\AERROR/
      end
    end

    class << self

      def stations
        @stations ||= Ellington::StationList.new(self)
      end

      def goal(*states)
        @goal ||= Ellington::Goal.new(*states)
      end

      def connections
        @connections ||= {}
      end

      def station_completed(info)
        if info[:station] == stations.last
          changed
          notify_observers info
        end
      end

    end

  end
end
