module Ellington
  class Route
    attr_reader :name, :lines

    def initialize(name)
      @name = name
      @lines = []
    end

    def add_line(line)
      line.route = self
      lines << line
    end

  end
end
