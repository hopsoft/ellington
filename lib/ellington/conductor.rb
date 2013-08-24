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
      return unless verify(passenger) && passenger.locked?
      route.lines.first.board passenger
    end
  end
end
