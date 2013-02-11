require "forwardable"

module Ellington
  class Route
    extend Forwardable
    def_delegators :"self.class", :lines, :goal, :fault, :transfers

    class << self
      def lines
        @lines ||= Ellington::LineList.new(self)
      end

      def goal(*line_goals)
        @goal ||= line_goals.flatten
      end

      def fault
        lines.map(&:states).map(&:keys).flatten - goal
      end

      def transfers(transfers)
        @transfers = transfers
      end
    end
  end
end
