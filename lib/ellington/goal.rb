require "delegate"

module Ellington
  class Goal < SimpleDelegator

    def initialize(*states)
      super states
    end

    def achieved?(passenger)
      return false if passenger.nil?
      include? passenger.current_state
    end

  end
end
