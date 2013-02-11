require "delegate"

module Ellington
  class StationList < SimpleDelegator
    attr_reader :line

    def initialize(line)
      @line = line
      @inner_list = UniqueTypeArray.new
      super @inner_list
    end

    def push(station)
      inner_list << station
      station.line = line
    end

    alias_method :<<, :push

    protected 

    attr_reader :inner_list
  end
end
