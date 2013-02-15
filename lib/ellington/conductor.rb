require "thread"

module Ellington
  class Conductor
    attr_reader :route

    def initialize(route)
      @route = route
      @conducting = false
    end

    def conducting?
      @conducting
    end

    def start
      return if conducting?

      mutex.synchronize do
        @stop = false
        @conducting = true
      end

      @thread = Thread.new do
        loop do
          if @stop
            mutex.synchronize { @conducting = false }
            Thread.current.exit
          end
          gather_passengers.each do |passenger|
            escort(passenger)
          end
        end
      end
    end

    def stop
      mutex.synchronize { @stop = true }
    end

    def wait
      thread.join
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

    protected

    attr_reader :thread

    def mutex
      @mutex ||= Mutex.new
    end

  end
end
