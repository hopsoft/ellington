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
          catalog
        end
      end

      def goal(*line_goals)
        @goal ||= Ellington::Goal.new(*line_goals.map(&:to_a).flatten)
      end

      def fault
        @fault ||= states.keys - goal.to_a
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
