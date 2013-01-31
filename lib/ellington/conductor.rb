module Ellington
  class Conductor
    attr_reader :route, :wait

    def initialize(route, wait)
      @route = route
      @wait = wait
    end

    # The run loop.
    def conduct
      while true
        passengers = gather_passengers
        passengers.each do |passenger|
          escort(passenger) if verify(passenger, ticket)
        end
        sleep wait
      end
    end

    # Determines if a passenger can ride the route.
    def verify(passenger)
      raise Ellington::NotImplementedError
    end

    def gather_passengers
      raise Ellington::NotImplementedError
    end


    # Puts a passenger onto a route.
    def escort(passenger)
      raise Ellington::NotImplementedError
    end

  end
end
