require "observer"
require "forwardable"

module Ellington

  class Station
    extend Forwardable
    include Observable
    attr_accessor :line
    def_delegators :line, :route

    def name
      @name ||= "#{self.class.name} <member of> #{line.name}"
    end

    def state_name(state)
      :"#{state.to_s.upcase.ljust(6, ".")} #{name}"
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
        notify_observers Ellington::StationInfo.new(self, passenger, attendant.passenger_transitions.first, options)
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

    def state(passenger)
      case passenger.current_state
      when passed then "PASS"
      when failed then "FAIL"
      when errored then "ERROR" 
      end
    end

  end

end
