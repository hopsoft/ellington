require "delegate"

module Ellington
  class LineCollection < SimpleDelegator
    attr_reader :route

    def initialize(route)
      @route = route
      @inner_list = UniqueArray.new
      super @inner_list
    end

    def push(line)
      line.route = route
      inner_list << line
    end

    alias_method :<<, :push

    protected 

    attr_reader :inner_list
  end
end
