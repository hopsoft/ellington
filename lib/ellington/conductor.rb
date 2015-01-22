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
      if !passenger.is_a?(Ellington::Passenger)
        ticket = Ellington::Ticket.new
        passenger = Ellington::Passenger.new(passenger, ticket: ticket, state_history: [])
      end
      passenger.current_state = route.initial_state
      return unless verify(passenger)
      route.lines.first.board passenger
    end
  end
end
