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

    def name
      @name ||= "#{self.class.name} <member of> #{route.name}"
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

    def state(passenger)
      case
      when passed.satisfied?(passenger) then "PASS"
      when failed.satisfied?(passenger) then "FAIL"
      when errored.satisfied?(passenger) then "ERROR"
      end
    end

    def station_completed(info)
      if info.station == stations.last
        changed
        notify_observers info
        log info
        log info, true
      else
        log info
      end
    end

    private

    def log(info, line_completed=false)
      return unless Ellington.logger
      return unless Ellington.logger.level <= Logger::INFO

      message = [] 
      if line_completed
        message << "LINE COMPLETED"
        message << "[line_state:#{state(info.passenger)}]"
      else
        message << "STATION COMPLETED"
      end
      message << "[station_state:#{info.station.state(info.passenger)}]"
      message << "[passenger_state:#{info.passenger.current_state}]"
      message << "[station:#{info.station.name}]"
      message << "[line:#{name}]"
      message << "[old_passenger_state:#{info.transition.old_state}]"
      route.log_passenger_attrs.each do |attr|
        message << "[#{attr}:#{info.passenger.send(attr)}]"
      end

      Ellington.logger.info message.join(" ")
    end

  end
end
