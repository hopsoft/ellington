require "observer"
require "forwardable"

module Ellington

  class Station
    extend Forwardable
    include Observable
    attr_reader :name, :states, :line
    def_delegator :"self.class", :states

    class << self
      attr_reader :states

      def transitions_passenger_to(*states)
        if states.length != 3
          raise Ellington::InvalidStates.new("Must provide exactly 3 states.")
        end
        @states = states
      end
    end

    def initialize(name=nil)
      @name = name || self.class.name
    end

    def line=(value)
      raise Ellington::StationAlreadyBelongsToLine unless @line.nil?
      @line=value
    end

    def can_engage?(passenger, options={})
      passenger.locked? && passenger.states.can_transition?(passenger.current_state => states)
    end

    def engage(passenger, options={})
      raise Ellington::NotImplementedError
    end

    def call(passenger, options={})
      if can_engage?(passenger)
        attendant = Ellington::Attendant.new(self)
        passenger.add_observer attendant
        engage passenger, options
        passenger.delete_observer attendant
        raise Ellington::StateTransitionLimitExceeded unless attendant.approve?

        transition = attendant.passenger_transitions.first

        info = {
          :route                => (line ? line.route.name : nil),
          :line                 => (line ? line.name : nil),
          :station              => self.class.name,
          :passenger            => passenger,
          :old_state            => (transition ? transition.old_state : nil),
          :new_state            => (transition ? transition.new_state : nil),
          :ticket_goal_achieved => passenger.ticket.goal_achieved?,
          :route_goal_achieved  => (line && line.route ? line.route.goal.achieved?(passenger) : false),
          :line_goal_achieved   => (line ? line.goal.achieved?(passenger) : false)
        }

        changed
        notify_observers info

        if Ellington.logger
          message = info.map{ |key, value| "#{key}:#{value}" }.join(" ")
          Ellington.logger.info message
        end
      end

      passenger
    end
  end

end
