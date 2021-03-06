require "delegate"

module Ellington
  class StationList < SimpleDelegator
    attr_reader :line_class

    def initialize(line_class)
      @line_class = line_class
      @inner_list = UniqueTypeArray.new
      super @inner_list
    end

    def push(station)
      value = inner_list << station
      station.line_class = line_class
      value
    end
    alias_method :<<, :push

    def add(station)
      push(station).last
    end

    def find_by_type(type)
      find { |entry| entry.is_a? type }
    end

    protected

    attr_reader :inner_list
  end
end
