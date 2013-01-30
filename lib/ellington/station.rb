module Ellington

  # Superclass for all stations.
  # Performs logic for a passenger.
  # May transition the passenger's state exactly once.
  # The station doors may not open if the station's logic can't perform the desired transition.
  class Station
    attr_reader :line, :transitions, :attendant

    def initialize(line, transitions, attendant)
      @line = line
      @transitions = transitions
      @attendant = attendant
    end

    # abstract method
    def open_doors(passenger, options={})
      message = "#{self.class.name}#open_doors has not been implemented."
      raise Ellington::NotImplementedError.new(message)
    end

    def call(passenger, options={})
      return unless attendant.verify?(self, passenger)

      open_doors(passenger, options)

      if attendant.passenger_transitions.size > 1
        message = "Station #{self.class.name} transitioned the passenger [#{attendant.passenger_transitions.size}] times."
        raise Ellington::StateTransitionLimitExceeded.new(message)
      end
    end
  end

end
