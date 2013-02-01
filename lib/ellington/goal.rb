module Ellington
  class Goal

    def initialize(*states)
      @inner_list = states.map(&:to_s)
      inner_list.freeze
    end

    def include?(state)
      inner_list.include? state.to_s
    end

    def achieved?(passenger)
      return false if passenger.nil?
      include? passenger.current_state.to_s
    end

    protected

    attr_reader :inner_list

  end
end
