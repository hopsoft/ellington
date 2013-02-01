require "observer"

module Ellington

  class Station
    include Observable
    attr_reader :name, :states, :line

    def initialize(name, *states)
      if states.length != 3
        raise Ellington::InvalidStates.new("Must provide exactly 3 states.")
      end
      @name = name
      @states = states
    end

    def line=(value)
      raise Ellington::StationAlreadyBelongsToLine unless @line.nil?
      @line=value
    end

    def can_engage?(passenger, options={})
      passenger.locked? && passenger.states.can_transition?(passenger.current_state => states)
    end

    def engage(passenger, options={})
      raise Ellington::NotImplementedError
    end

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
