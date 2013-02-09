require "delegate"

module Ellington
  class UniqueArray < SimpleDelegator

    def initialize
      @inner_list = []
      super inner_list
    end

    def push(value)
      check value
      inner_list.push value
    end

    def <<(value)
      check value
      inner_list << value
    end

    protected

    attr_reader :inner_list

    def check(value)
      raise Ellington::ListAlreadyContainsValue if inner_list.include?(value)
    end

  end
end
