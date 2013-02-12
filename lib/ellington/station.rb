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

        info = StationInfo.new(self, passenger, attendant.passenger_transitions.first)

        changed
        notify_observers info

        if Ellington.logger
          message = info.to_hash.map{ |key, value| "#{key}:#{value}" }.join(" ")
          Ellington.logger.info message
        end
      end

      passenger
    end

    def pass(passenger)
      passenger.transition_to passed
    end

    def fail(passenger)
      passenger.transition_to failed
    end

    def error(passenger)
      passenger.transition_to errored
    end

  end

end
