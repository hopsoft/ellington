require "forwardable"
require "observer"
require_relative "has_targets"

module Ellington
  class Line
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
    end

    extend Forwardable
    include Observable
    include HasTargets

    attr_accessor :route_class, :route

    def_delegators :"self.class",
      :stations,
      :pass_target,
      :passed,
      :goal

    def initialize
      if stations.empty?
        message = "#{self.class.name} has no stations!"
        raise Ellington::NoStationsDeclared.new(message)
      end

      if goal.empty?
        message = "#{self.class.name} has no goal!"
        raise Ellington::NoGoalDeclared.new(message)
      end
    end

    def initial_states
      stations.first.initial_states
    end

    def board(passenger, options={})
      formula.run passenger, options
    end

    def boarded?(passenger)
      !(passenger.state_history & states.keys).empty?
    end

    def name
      @name ||= "#{route_class.name} #{self.class.name}"
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
          station.states.each do |state, transitions|
            catalog[state] = transitions.nil? ? nil : transitions.dup
          end

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
          return complete_line(line_info)
      end

      log line_info, :station_completed => true
    end

    protected

    def complete_line(line_info)
      log line_info, :station_completed => true
      log line_info, :line_completed => true
      changed
      notify_observers line_info
    end

    def log(line_info, options={})
      return unless Ellington.logger
      Ellington.logger.info line_info.log_message(options)
    end

  end
end
