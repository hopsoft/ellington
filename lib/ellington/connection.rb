module Ellington
  class Connection
    attr_reader :line, :goal

    def initialize(line, goal)
      @line = line
      @goal = goal
    end

  end
end
