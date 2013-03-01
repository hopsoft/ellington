require "delegate"
require "fileutils"

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
      include HasTargets
      attr_reader :initialized

      def inherited(subclass)
        (@subclasses ||= []) << subclass
      end

      def generate_graphs(dir, options={})
        options[:format] ||= :svg
        FileUtils.mkdir_p(dir)
        @subclasses.each do |subclass|
          Ellington::Visualizer.new(subclass.new, dir, options[:format]).graph_all
        end
      end

      def initialized?
        @initialized
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

      def connect_to(line, options)
        type = options.keys.first
        states = options[type]
        connections << Ellington::Connection.new(line, type, states)
      end

      def log_options(options={})
        @log_options ||= begin
          options[:passenger] ||= []
          options[:options] ||= []
          options
        end
      end

      def line_completed(line_info)
        route_info = Ellington::RouteInfo.new(self, line_info)

        required_connections = connections.select do |connection|
          connection.required?(route_info.passenger)
        end

        if required_connections.empty?
          if passed.satisfied?(route_info.passenger) || failed.satisfied?(route_info.passenger)
            log route_info
          end
          Ellington.logger.info "\n" if Ellington.logger
          binding.pry
        end

        required_connections.each do |connection|
          connection.line.board route_info.passenger, route_info.options
        end
      end

      private

      def log(route_info)
        return unless Ellington.logger
        Ellington.logger.info route_info.log_message
      end

    end

  end
end
