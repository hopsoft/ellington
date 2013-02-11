module Ellington
  class Connection
    attr_reader :line, :states

    def initialize(line, states)
      @line = line
      @states = states.to_a
    end

  end
end
