require "delegate"

module Ellington
  class Ticket < SimpleDelegator

    def initialize(context)
      super context
    end

  end
end
