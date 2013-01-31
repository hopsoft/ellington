module Ellington
  class Route < SimpleDelegator
    attr_reader :name, :head

    def initialize(name)
      @name = name
      @inner_hash = {}
      super(@inner_hash)
    end

    def []=(name, line)
      line.route = self
      inner_hash[name] = line
      @head ||= line
    end

    protected

    attr_reader :inner_hash

  end
end
