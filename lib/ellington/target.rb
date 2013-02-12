require "delegate"

module Ellington
  class Target < SimpleDelegator

    def initialize(*states)
      @inner_list = states.flatten.map(&:to_sym)
      super inner_list
    end

    def include?(state)
      inner_list.include? state.to_sym
    end

    def satisfied?(passenger)
      return false if passenger.nil?
      include? passenger.current_state.to_sym
    end

    protected

    attr_reader :inner_list

  end
end
