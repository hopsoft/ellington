module Ellington
  class Conductor
    attr_reader :route, :conducting

    def initialize(route)
      @route = route
      @conducting = false
    end

    def start(delay)
      @stop = false
      @conducting = true
      loop do
        if @stop
          @conducting = false
          break
        end
        gather_passengers.each { |passenger| escort(passenger) }
        sleep delay
      end
    end

    def stop
      @stop = true
    end

    def verify(passenger)
      raise Ellington::NotImplementedError
    end

    def gather_passengers
      raise Ellington::NotImplementedError
    end

    def escort(passenger)
      return unless verify(passenger)
      passenger.lock
      route.head.board passenger
    end

  end
end
