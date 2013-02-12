require "forwardable"

module Ellington
  class Route
    extend Forwardable
    def_delegators :"self.class", :lines, :states, :goal, :fault, :connections

    class << self

      def lines
        @lines ||= Ellington::LineList.new(self)
      end

      def states
        @states ||= begin
          catalog = StateJacket::Catalog.new
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

      def goal(*line_goals)
        @goal ||= Ellington::Goal.new(*line_goals.flatten)
      end

      def fault
        @fault ||= (states.keys - goal).delete_if do |state|
          state.to_s =~ /\AERROR/i
        end
      end

      def connections
        @connections ||= Ellington::ConnectionList.new
      end

      def connect_to(line, options)
        connections << Ellington::Connection.new(line, options[:on])
      end

    end
  end
end
