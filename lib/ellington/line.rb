require "forwardable"
require "observer"

module Ellington
  class Line
    extend Forwardable
    include Observable
    include HasTargets
    attr_accessor :route
    def_delegators :"self.class",
      :stations,
      :pass_target,
      :passed,
      :goal,
      :station_completed

    def board(passenger, options={})
      formula.run passenger, options
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
            catalog[station.passed] = next_station.states.keys
          end
        end
        catalog.lock
        catalog
      end
    end

    class << self
      include Observable

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
        if info[:station] == stations.last
          changed
          notify_observers info
        end
      end

    end

  end
end
