require "delegate"

module Ellington
  class LineList < SimpleDelegator
    attr_reader :route_class

    def initialize(route_class)
      @route_class = route_class
      @inner_list = UniqueTypeArray.new
      super @inner_list
    end

    def push(line)
      value = inner_list << line
      line.route_class = route_class
      value
    end
    alias_method :<<, :push

    protected

    attr_reader :inner_list
  end
end
