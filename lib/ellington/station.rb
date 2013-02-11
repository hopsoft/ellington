require "observer"

module Ellington

  class Station
    include Observable
    attr_accessor :route, :line

    def full_name
      "#{self.class.name} > #{line.name} > #{route.name}"
    end

    def states
      pass = :"PASS #{full_name}"
      fail = :"FAIL #{full_name}"
      error = :"ERROR #{full_name}"
      catalog = StateJacket::Catalog.new
      catalog.add pass
      catalog.add fail
      catalog.add error => [pass, fail, error]
      catalog
    end

    def can_engage?(passenger, options={})
      passenger.locked? && 
        route.states.can_transition?(passenger.current_state => states.keys)
    end

    def engage(passenger, options={})
      raise Ellington::NotImplementedError
    end

    def call(passenger, options={})
      if can_engage?(passenger)
        attendant = Ellington::Attendant.new(self)
        passenger.add_observer attendant
        engage passenger, options
        passenger.delete_observer attendant
        raise Ellington::AttendandDisapproves unless attendant.approve?

        changed
        notify_observers nil # TODO: create payload for observers

        #if Ellington.logger
        #  message = info.map{ |key, value| "#{key}:#{value}" }.join(" ")
        #  Ellington.logger.info message
        #end
      end

      passenger
    end

    def pass(passenger)
      passenger.transition_to states[:pass]
    end

    def fail(passenger)
      passenger.transition_to states[:fail]
    end

    def error(passenger)
      passenger.transition_to states[:error]
    end

  end

end
