require "delegate"

module Ellington
  class UniqueTypeArray < SimpleDelegator

    def initialize
      @inner_list = []
      super inner_list
    end

    def push(value)
      check value
      inner_list.push value
    end

    alias_method :<<, :push

    def contains_a?(klass)
      each do |entry|
        return true if entry.class == klass
      end
      false
    end

    protected

    attr_reader :inner_list

    def check(value)
      if contains_a?(value.class)
        raise Ellington::ListAlreadyContainsType.new("List already contains a #{value.class.name} type!")
      end
    end

  end
end
