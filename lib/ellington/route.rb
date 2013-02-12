require "forwardable"

module Ellington
  class Route
    extend Forwardable
    def_delegators :"self.class",
      :lines,
      :states,
      :initial_state,
      :goal,
      :fault,
      :connections,
      :connect_to,
      :line_completed

    class << self

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

      def goal(*line_goals)
        @goal ||= Ellington::Target.new(*line_goals.flatten)
      end

      def fault
        @fault ||= begin
          state_list = states.keys - goal
          state_list.reject! { |state| state.to_s =~ /\AERROR/ }
          Ellington::Target.new *state_list
        end
      end

      def connections
        @connections ||= Ellington::ConnectionList.new
      end

      def connect_to(line, options)
        connections << Ellington::Connection.new(line, options[:on])
      end

      def line_completed(info)
      end

    end
  end
end
