require "delegate"

module Ellington
  class Line < SimpleDelegator
    attr_reader :name, :goal, :route

    def initialize(name, goal=nil)
      @name = name
      @goal = goal || Ellington::Goal.new
      @formula = Hero::Formula[name]
      formula.steps.clear
      super []
    end

    def route=(value)
      raise Ellington::LineAlreadyBelongsToRoute unless route.nil?
      @route = value
    end

    def <<(station)
      station.line = self
      push station
      formula.add_step station.name, station
    end

    def board(passenger)
      formula.run passenger
    end

    protected

    attr_reader :formula

  end
end
