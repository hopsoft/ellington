require "delegate"

module Ellington
  class Goal < SimpleDelegator

    def initialize(*states)
      @inner_list = states.map(&:to_sym)
      super inner_list
    end

    def include?(state)
      inner_list.include? state.to_sym
    end

    def achieved?(passenger)
      return false if passenger.nil?
      include? passenger.current_state.to_sym
    end

    protected

    attr_reader :inner_list

  end
end
