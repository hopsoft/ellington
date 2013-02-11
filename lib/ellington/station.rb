require "observer"

module Ellington

  class Station
    include Observable
    attr_accessor :route, :line

    def full_name
      "#{self.class.name}->#{line.name}->#{route.name}"
    end

    def can_engage?(passenger, options={})
      passenger.locked? && passenger.states.can_transition?(passenger.current_state => states)
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

        transition = attendant.passenger_transitions.first

        changed
        notify_observers info

        if Ellington.logger
          message = info.map{ |key, value| "#{key}:#{value}" }.join(" ")
          Ellington.logger.info message
        end
      end

      passenger
    end

    class << self
      attr_reader :states

      def transitions_passenger_to(*states)
        if states.length != 3
          raise Ellington::InvalidStates.new("Must provide exactly 3 states.")
        end
        @states = states
      end
    end

  end

end
