module Ellington
  class Route

    class << self
      include HasTargets

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
        @initial_state ||= :"PRE #{name}"
      end

      def pass_target(*line_goals)
        @goal ||= Ellington::Target.new(*line_goals.flatten)
      end
      alias_method :pass, :pass_target
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
