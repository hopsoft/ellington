require "observer"

module Ellington

  class Station
    include Observable
    attr_accessor :route, :line

    def full_name
      @full_name ||= "#{self.class.name} > #{line.name}"
    end

    def state_name(state)
      :"#{state.to_s.upcase} #{full_name}"
    end

    def passed
      @pass_state ||= state_name(:pass)
    end

    def failed
      @fail_state ||= state_name(:fail)
    end

    def errored
      @error_state ||= state_name(:error)
    end

    def states
      @states ||= begin
        catalog = StateJacket::Catalog.new
        catalog.add passed
        catalog.add failed
        catalog.add errored => [ passed, failed, errored ]
        catalog.lock
        catalog
      end
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
      passenger.transition_to pass_state
    end

    def fail(passenger)
      passenger.transition_to fail_state
    end

    def error(passenger)
      passenger.transition_to error_state
    end

  end

end
