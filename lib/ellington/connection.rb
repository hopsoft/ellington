module Ellington
  class Connection
    attr_reader :line, :states, :strict

    def initialize(line, *states, strict: false)
      @line = line
      @states = Ellington::Target.new(*states)
      @strict = strict
    end

    def required?(passenger)
      return false if line.boarded?(passenger)
      return (passenger.state_history & states).length == states.length if strict
      states.satisfied?(passenger)
    end

  end
end
