module Ellington
  class Connection
    attr_reader :state, :line

    def initialize(state, line)
      @state = state
      @line = line
    end

  end
end
