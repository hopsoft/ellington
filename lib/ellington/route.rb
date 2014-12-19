require "delegate"
require "fileutils"
require "observer"
require_relative "has_targets"

module Ellington
  class Route < SimpleDelegator

    def initialize
      super self.class

      if lines.empty?
        message = "#{self.class.name} has no lines!"
        raise Ellington::NoLinesDeclared.new(message)
      end

      if goal.empty?
        message = "#{self.class.name} has no lines!"
        raise Ellington::NoGoalDeclared.new(message)
      end

      initialize_lines
      states
    end

    def initialize_lines
      lines.each do |line|
        line.route = self
        line.add_observer self, :line_completed
        line.stations.each do |station|
          station.line = line
          station.add_observer line, :station_completed
        end
      end
    end

    class << self
      include Observable
      include HasTargets
      attr_reader :initialized

      def inherited(subclass)
        (@subclasses ||= []) << subclass
      end

      def initialized?
        @initialized
      end

      def board(passenger)
        lines.first.board passenger
      end

      def lines
        @lines ||= Ellington::LineList.new(self)
      end

      def states
        @states ||= begin
          catalog = StateJacket::Catalog.new
          catalog.add initial_state => lines.first.stations.first.states.keys

          lines.each do |line|
            line.states.each do |state, transitions|
              catalog[state] = transitions.nil? ? nil : transitions.dup
            end
          end

          connections.each do |connection|
            connection.states.each do |state|
              catalog[state] ||= []
              catalog[state].concat connection.line.stations.first.states.keys
            end
          end

          catalog.lock
          catalog
        end
      end

      def initial_state
        @initial_state ||= "PRE #{name}"
      end

      def pass_target(*line_goals)
        @goal ||= Ellington::Target.new(*line_goals.flatten)
      end
      alias_method :passed, :pass_target
      alias_method :goal, :pass_target

      def connections
        @connections ||= Ellington::ConnectionList.new
      end

      def connect(line, after: [], strict: false)
        connections << Ellington::Connection.new(line, *after, strict: false)
      end

      def passenger_attrs_to_log
        @passenger_attrs_to_log ||= []
      end

      def set_passenger_attrs_to_log(*attrs)
        @passenger_attrs_to_log = attrs
      end

      def line_completed(line_info)
        route_info = Ellington::RouteInfo.new(self, line_info)
        connections = required_connections(route_info.passenger)
        return complete_route(route_info) if connections.empty?
        connections.each do |connection|
          connection.line.board route_info.passenger
        end
      end

      protected

      def complete_route(route_info)
        if passed.satisfied?(route_info.passenger) || failed.satisfied?(route_info.passenger)
          log route_info.route_completed_message
          changed
          notify_observers route_info
        end
      end

      def required_connections(passenger)
        connections.select do |connection|
          connection.required?(passenger)
        end
      end

      def log(message)
        return unless Ellington.logger
        Ellington.logger.info message
      end

    end

  end
end
