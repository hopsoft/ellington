require "delegate"

module Ellington
  class Route < SimpleDelegator

    def initialize
      super self.class
      init unless initialized?
    end

    class << self
      include HasTargets
      attr_reader :initialized

      def initialized?
        @initialized
      end

      def init
        initialize_lines
        states
        @initialized = true
      end

      def initialize_lines
        lines.each do |line|
          line.add_observer self, :line_completed
          line.stations.each do |station|
            station.add_observer line, :station_completed
          end
        end
      end

      def board(passenger, options={})
        lines.first.board passenger, options
      end

      def lines
        @lines ||= Ellington::LineList.new(self)
      end

      def states
        @states ||= begin
          catalog = StateJacket::Catalog.new
          catalog.add initial_state => lines.first.stations.first.states.keys

          lines.each do |line|
            catalog.merge! line.states
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
        @initial_state ||= :"#{"PRE".ljust(6, ".")} #{name}"
      end

      def pass_target(*line_goals)
        @goal ||= Ellington::Target.new(*line_goals.flatten)
      end
      alias_method :passed, :pass_target
      alias_method :goal, :pass_target

      def connections
        @connections ||= Ellington::ConnectionList.new
      end

      def connect_to(line, options)
        connections << Ellington::Connection.new(line, options[:if])
      end

      def line_completed(info)
      end

    end

  end
end
