module Ellington
  class Connection
    attr_reader :line, :states

    def initialize(line, *states)
      @line = line
      @states = Ellington::Target.new(*states)
    end

  end
end
