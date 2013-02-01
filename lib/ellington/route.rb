module Ellington
  class Route < SimpleDelegator
    attr_reader :name, :goal, :head

    def initialize(name, goal=[])
      @name = name
      @goal = goal
      @inner_hash = {}
      super(@inner_hash)
    end

    def []=(name, line)
      line.route = self
      inner_hash[name] = line
      @head ||= line
    end

    def goal_achieved?(passenger)
      goal.include? passenger.current_state
    end

    protected

    attr_reader :inner_hash

  end
end
