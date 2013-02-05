module Ellington
  class Conductor
    attr_reader :route, :conducting
    attr_accessor :stop

    def initialize(route)
      @route = route
      @conducting = false
    end

    def start(delay)
      @stop = false
      loop do
        if stop
          @conducting = false
          break
        end
        @conducting = true
        gather_passengers.each { |passenger| escort(passenger) }
        sleep delay
      end
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
