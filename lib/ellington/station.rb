require "observer"
require "forwardable"

module Ellington

  class Station
    extend Forwardable
    include Observable
    attr_accessor :line_class, :line
    def_delegators :line, :route

    def initial_states
      route.states.keys.select do |state|
        route.states.can_transition?(state => states.keys)
      end
    end

    def name
      @name ||= "#{line_class.name} #{self.class.name}"
    end

    def state_name(state)
      "#{state.to_s.upcase} #{name}"
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

    def can_engage?(passenger)
      return false unless route.states.can_transition?(passenger.current_state => states.keys)
      return false if passenger.state_history_includes?(passed)
      true
    end

    def engage(passenger)
      raise Ellington::NotImplementedError
    end

    def engage_and_transition(passenger)
      begin
        if !!engage(passenger)
          pass_passenger passenger
        else
          fail_passenger passenger
        end
      rescue StandardError => e
        Ellington.logger.error "Failure while engaging passenger! #{e}" if Ellington.logger
        error_passenger passenger
      end
    end

    def call(passenger, _=nil)
      if can_engage?(passenger)
        attendant = Ellington::Attendant.new(self)
        passenger.add_observer attendant
        engage_and_transition passenger
        passenger.delete_observer attendant
        raise Ellington::AttendantDisapproves unless attendant.approve?
        changed
        notify_observers Ellington::StationInfo.new(self, passenger, attendant.passenger_transitions.first)
      end

      passenger
    end

    def pass_passenger(passenger)
      passenger.transition_to passed, state_jacket: route.states
    end

    def fail_passenger(passenger)
      passenger.transition_to failed, state_jacket: route.states
    end

    def error_passenger(passenger)
      passenger.transition_to errored, state_jacket: route.states
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

