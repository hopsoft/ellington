require "delegate"

module Ellington
  class StationCollection < SimpleDelegator
    attr_reader :line

    def initialize(line)
      @line = line
      @inner_list = UniqueArray.new
      super @inner_list
    end

    def push(station)
      station.line = line
      inner_list << station
    end

    alias_method :<<, :push

    protected 

    attr_reader :inner_list
  end
end
