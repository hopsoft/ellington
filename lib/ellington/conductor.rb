require "thread"
require "monitor"

module Ellington
  class Conductor
    attr_reader :route, :conducting

    def initialize(route)
      @route = route
      @conducting = false
    end

    def start(delay)
      return if conducting

      synchronize do
        @stop = false
        @conducting = true
      end

      Thread.new do
        loop do
          if @stop
            synchronize { @conducting = false }
            break
          end
          gather_passengers.each { |passenger| escort(passenger) }
          sleep delay
        end
      end
    end

    def stop
      synchronize { @stop = true }
    end

    def verify(passenger)
      raise Ellington::NotImplementedError
    end

    def gather_passengers
      raise Ellington::NotImplementedError
    end

    def escort(passenger)
      return unless verify(passenger)
      return if passenger.locked?
      passenger.lock
      route.head.board passenger
    end

  end
end
