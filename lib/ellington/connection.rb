module Ellington
  class Connection
    attr_reader :line, :type, :states

    def initialize(line, type, *states)
      @line = line
      @type = type
      @states = Ellington::Target.new(*states)
    end

    def required?(passenger)
      return false if line.boarded?(passenger)

      if type == :if_currently
        return states.satisfied?(passenger) 
      end

      if type == :if_ever
        return (passenger.state_history & states).length == states.length
      end

      false
    end

  end
end
