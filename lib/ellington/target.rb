require "delegate"

module Ellington
  class Target < SimpleDelegator

    def initialize(*states)
      @inner_list = states.flatten
      super inner_list
    end

    def include?(state)
      inner_list.include? state
    end

    def satisfied?(passenger)
      return false if passenger.nil?
      include? passenger.current_state
    end

    protected

    attr_reader :inner_list

  end
end
