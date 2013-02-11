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
      inner_list << line
      line.route = route
      line.stations.each do |station|
        station.route = route
      end
    end

    alias_method :<<, :push

    protected 

    attr_reader :inner_list
  end
end
