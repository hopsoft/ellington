require "forwardable"
require "observer"

module Ellington
  class Line
    extend Forwardable
    include Observable
    include HasTargets

    def_delegators :"self.class",
      :route,
      :route=,
      :stations,
      :pass_target,
      :passed,
      :goal,
      :station_completed

    def board(passenger, options={})
      formula.run passenger, options
    end

    def name
      @name ||= "#{self.class.name} member of #{route.name}"
    end

    def formula
      @formula ||= begin
        Hero::Formula[name]
        Hero::Formula[name].steps.clear
        stations.each do |station|
          Hero::Formula[name].add_step station
        end
        Hero::Formula[name]
      end
    end

    def states
      @states ||= begin
        catalog = StateJacket::Catalog.new
        stations.each_with_index do |station, index|
          catalog.merge! station.states
          if index < stations.length - 1
            next_station = stations[index + 1]
            catalog[station.passed] = next_station.states.keys
          end
        end
        catalog.lock
        catalog
      end
    end

    class << self
      include Observable
      attr_accessor :route

      def stations
        @stations ||= Ellington::StationList.new(self)
      end

      def pass_target(*states)
        @goal ||= Ellington::Target.new(*states)
      end
      alias_method :passed, :pass_target
      alias_method :goal, :pass_target

      def connections
        @connections ||= {}
      end

      def station_completed(info)
        if info.station == stations.last
          changed
          notify_observers info
        end
      end

    end

  end
end
