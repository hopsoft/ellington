module Ellington
  class Connection
    attr_reader :line, :states

    def initialize(line, states)
      @line = line
      @states = states
    end

  end
end
