require "forwardable"

module Ellington
  class Route
    extend Forwardable
    attr_reader :name, :goal, :head
    def_delegators :inner_hash, :[], :length

    def initialize(name, goal=nil)
      @name = name
      @goal = goal || Ellington::Goal.new
      @inner_hash = {}
    end

    def add(line)
      line.route = self
      inner_hash[line.name] = line
      @head ||= line
    end

    protected

    attr_reader :inner_hash

  end
end
