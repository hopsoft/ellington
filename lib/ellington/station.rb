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
      message = "#{self.class.name}#open_doors has not been implemented in the subclass."
      raise Ellington::NotImplementedError.new(message)
    end

    def call(passenger, options={})
      # TODO: ask attendant if the doors should open

      open_doors(passenger, options)

      # TODO: verify that the passenger has only transitioned once
    end
  end

end
