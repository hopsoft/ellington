module Ellington
  class Goal

    def initialize(*states)
      @inner_list = states.map(&:to_sym)
      inner_list.freeze
    end

    def include?(state)
      inner_list.include? state.to_sym
    end

    def achieved?(passenger)
      return false if passenger.nil?
      include? passenger.current_state.to_sym
    end

    def to_a
      inner_list
    end

    protected

    attr_reader :inner_list

  end
end
