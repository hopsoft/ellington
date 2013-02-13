require "delegate"

module Ellington
  class LineList < SimpleDelegator
    attr_reader :route

    def initialize(route)
      @route = route
      @inner_list = UniqueTypeArray.new
      super @inner_list
    end
    
    def push(line)
      value = inner_list << line
      line.route = route
      value
    end
    alias_method :<<, :push

    protected 

    attr_reader :inner_list
  end
end
