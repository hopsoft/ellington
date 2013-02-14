require "thread"

module Ellington
  class Conductor
    attr_reader :route, :conducting

    def initialize(route)
      @route = route
      @conducting = false
    end

    def start(delay)
      return if conducting

      mutex.synchronize do
        @stop = false
        @conducting = true
      end

      thread = Thread.new do
        loop do
          if @stop
            mutex.synchronize { @conducting = false }
            break
          end
          gather_passengers.each do |passenger|
            escort(passenger)
          end
          sleep delay
        end
      end
      thread.join
    end

    def stop
      mutex.synchronize { @stop = true }
    end

    def verify(passenger)
      true
    end

    def gather_passengers
      raise Ellington::NotImplementedError
    end

    def escort(passenger)
      return unless verify(passenger) && passenger.locked?
      route.lines.first.board passenger
    end

    private

    def mutex
      @mutex ||= Mutex.new
    end

  end
end
