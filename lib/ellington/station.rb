module Ellington

  # Superclass for all stations.
  #
  # A station performs business logic and transitions the passenger's state
  # 1 time based on the outcome.
  #
  # The possible states a station transitions to should include:
  #
  # * a passing state - indicates everything worked as expected
  # * a failing state - indicates the requirements to pass were not met
  # * an error state - indicates an error occured
  #
  # @example Example subclass
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
  class Station
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
      passenger.delete_observers
      if can_engage?(passenger)
        attendant = Ellington::Attendant.new(passenger)
        passenger.add_observer attendant
        engage passenger, options
        raise Ellington::StateTransitionLimitExceeded unless attendant.approves?
      end
      passenger
    end
  end

end
