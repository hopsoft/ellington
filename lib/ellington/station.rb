require "observer"
require "forwardable"

module Ellington

  class Station
    extend Forwardable
    include Observable
    attr_accessor :line
    def_delegators :line, :route

    def name
      @name ||= "#{self.class.name} member of #{line.name}"
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

        info = StationInfo.new(self, passenger, attendant.passenger_transitions.first)

        changed
        notify_observers info
        log info
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

    private

    def log(info)
      return unless Ellington.logger
  
      message = {
        :station          => self.name,
        :station_passed?  => info.passenger.current_state == passed,
        :station_failed?  => info.passenger.current_state == failed,
        :station_errored? => info.passenger.current_state == errored,
        :line             => line.name,
        :line_passed?     => line.passed.satisfied?(info.passenger),
        :line_failed?     => line.failed.satisfied?(info.passenger),
        :line_errored?    => line.errored.satisfied?(info.passenger),
        :route            => route.name,
        :route_passed?    => route.passed.satisfied?(info.passenger),
        :route_failed?    => route.failed.satisfied?(info.passenger),
        :route_errored?   => route.errored.satisfied?(info.passenger),
        :original_state   => info.transition.old_state,
        :current_state    => info.passenger.current_state,
        :passenger        => info.passenger.inspect
      }

      Ellington.logger.info message.inspect
    end

  end

end
