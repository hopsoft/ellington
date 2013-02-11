require "delegate"
module Ellington
  class ConnectionList < SimpleDelegator

    def initialize
      @inner_list = []
      super inner_list
    end

    def push(connection)
      check connection
      inner_list.push connection
    end

    alias_method :<<, :push

    protected

    attr_reader :inner_list

    def check(connection)
      matches = inner_list.select do |c| 
        c.line == connection && c.states == connection.states
      end
      raise Ellington::ListAlreadyContainsConnection unless matches.empty?
    end

  end
end
