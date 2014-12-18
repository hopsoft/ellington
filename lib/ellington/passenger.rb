require "observer"

module Ellington
  class Passenger < SimpleDelegator
    include Observable
    attr_accessor :context, :ticket
    attr_reader :route, :state_history

    def initialize(context, route, ticket: Ellington::Ticket.new, state_history: [])
      @context = context
      @route = route
      @ticket = ticket
      @state_history = state_history
      super context
    end

    def current_state
      return context.current_state if context.respond_to?(:current_state)
      @current_state
    end

    def current_state=(value)
      return context.current_state=(value) if context.respond_to?(:current_state=)
      @current_state = value
    end

    def state_history_includes?(*states)
      (state_history & states).length == states.length
    end

    def transition_to(new_state)
      if !route.states.can_transition?(current_state => new_state)
        message = "Cannot transition #{self.class.name} from:#{current_state} to:#{new_state}"
        raise Ellington::InvalidStateTransition.new(message)
      end

      old_state = current_state

      if context.respond_to?(:transition_to)
        return_value = context.transition_to(new_state)
      else
        self.current_state = new_state
      end

      state_history << new_state

      changed
      notify_observers Ellington::TransitionInfo.new(self, old_state, new_state)
      return_value || new_state
    end

  end
end
