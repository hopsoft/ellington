require "observer"

module Ellington

  # Superclass for all stations.
  #
  # A station performs business logic and transitions 
  # the passenger's state 1 time based on the outcome.
  #
  # The states should include:
  #
  # * a passing state - indicates everything worked as expected
  # * a failing state - indicates the requirements to pass were not met
  # * an error state - indicates an error occured
  #
  # @example Example subclass
  #
  #   class LastNameStation < Ellington::Station
  #     def initialize(line)
  #       state = {
  #         :first_name_passed => [
  #           :last_name_passed, 
  #           :last_name_failed, 
  #           :last_name_error
  #         ]
  #       }
  #       super(line, state)
  #     end
  #
  #     # Business logic that verifies the passenger's last name.
  #     def engage(passenger, options={})
  #       if passenger.last_name != "hopkins"
  #         passenger.transition_to(:last_name_passed)
  #       else
  #         passenger.transition_to(:last_name_failed)
  #       end
  #     rescue Exception => ex
  #       passenger.transition_to(:last_name_error)
  #     end
  #   end
  #
  class Station
    include Observable
    attr_reader :line, :state

    def initialize(line, state)
      @line = line
      @state = state
    end

    # Indicates if this station can peform it's transition on passenger.
    def can_engage?(passenger, options={})
      passenger.states.can_transition?(passenger.state => state.values)
    end

    # Abstract method that should be implemented in the subclass.
    # This is where the business logic will be applied.
    def engage(passenger, options={})
      raise Ellington::NotImplementedError
    end

    # Wraps #engage and is for internal use only.
    def call(passenger, options={})
      if can_engage?(passenger)
        attendant = Ellington::Attendant.new
        passenger.add_observer attendant
        engage passenger, options
        passenger.delete_observer attendant
        raise Ellington::StateTransitionLimitExceeded unless attendant.approve?
        changed
        notify_observers self, passenger, attendant.passenger_transitions
      end
      passenger
    end
  end

end
