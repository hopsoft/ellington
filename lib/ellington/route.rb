module Ellington
  class Route < SimpleDelegator
    attr_reader :name

    def initialize(name)
      @name = name
      super []
    end

    def <<(line)
      line.route = self
      push line
    end

  end
end
