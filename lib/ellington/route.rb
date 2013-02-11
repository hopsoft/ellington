require "forwardable"

module Ellington
  class Route
    extend Forwardable
    def_delegators :"self.class", :lines

    def goal
      self.class.instance_eval { @goal }
    end

    def transfers
      self.class.instance_eval { @transfers }
    end

    class << self
      def lines
        @lines ||= Ellington::LineCollection.new(self)
      end

      def goal(*lines)
        @goal = lines
      end

      def transfers(transfers)
        @transfers = transfers
      end
    end
  end
end
