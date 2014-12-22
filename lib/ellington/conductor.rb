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
      passenger = route.create_passenger(passenger) unless passenger.is_a?(Passenger)
      return unless verify(passenger)
      route.lines.first.board passenger
    end
  end
end
