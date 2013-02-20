require "forwardable"
require "observer"

module Ellington
  class Line
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
    end

    extend Forwardable
    include Observable
    include HasTargets

    def_delegators :"self.class",
      :route,
      :route=,
      :stations,
      :pass_target,
      :passed,
      :goal

    def board(passenger, options={})
      formula.run passenger, options
    end

    def boarded?(passenger)
      !(passenger.state_history & states.keys).empty?
    end

    def name
      @name ||= "#{self.class.name}::#{route.name}"
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

    def station_completed(station_info)
      line_info = Ellington::LineInfo.new(self, station_info)
      if line_info.station == stations.last ||
        line_info.passenger.current_state == line_info.station.failed
        log line_info, :station_completed => true
        log line_info, :line_completed => true
        changed
        notify_observers line_info
      else
        log line_info, :station_completed => true
        if line_info.passenger.current_state == line_info.station.errored
          Ellington.logger.info "\n" if Ellington.logger
        end
      end
    end

    private

    def log(line_info, options={})
      return unless Ellington.logger
      Ellington.logger.info line_info.log_message(options)
    end

  end
end
