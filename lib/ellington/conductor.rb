module Ellington
  class Conductor
    attr_reader :route, :wait

    def initialize(route, wait)
      @route = route
      @wait = wait
    end

    # The run loop.
    def conduct
      loop do
        gather_passengers.each do |passenger|
          escort(passenger) if verify(passenger)
        end
        sleep wait
      end
    end

    # Determines if a passenger can ride the route managed by this conductor.
    def verify(passenger)
      raise Ellington::NotImplementedError
    end

    def gather_passengers
      raise Ellington::NotImplementedError
    end

    # Puts a passenger onto a route.
    def escort(passenger)
      passenger.lock
      route.head.board passenger
    end

  end
end
