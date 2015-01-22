require_relative "route"
require_relative "passenger"

module Ellington
  class Conductor
    attr_reader :route

    def initialize(route)
      @route = route
    end

    # override this method in a subclass
    # to perform actual passenger verification
    def verify(passenger)
      true
    end

    def conduct(passenger)
      if !passenger.is_a?(Passenger)
        passenger = Passenger.new(passenger, ticket: Ellington::Ticket.new, state_history: [])
      end
      passenger.current_state = route.initial_state
      return unless verify(passenger)
      route.lines.first.board passenger
    end
  end
end
