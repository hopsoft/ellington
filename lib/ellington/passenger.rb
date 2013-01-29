require "delegate"
require "observer"

module Ellington
  class Passenger < SimpleDelegator
    include Observable
    attr_accessor :current_state
    attr_reader :states

    def initialize(context, ticket, states)
      super context
      @ticket = ticket
      @states = states
    end

    def can_travel?
      false
    end

    def effective_travel?(line, station)
      false
    end

    def lock
      @locked = true
    end

    def unlock
      @locked = false
    end

    def locked?
      @locked
    end

    def transition_to(new_state)
      if !locked?
        message = "Cannot transition an unlocked #{self.class.name}'s state"
        raise Ellington::InvalidStateTransition.new(message)
      end

      if !states.can_transition?(current_state => new_state)
        message = "Cannot transition #{self.class.name} from:#{current_state} to:#{new_state}"
        raise Ellington::InvalidStateTransition.new(message)
      end

      old_state = current_state
      self.current_state = new_state
      changed
      notify_observers self, old_state, new_state
      new_state
    end

  end
end
