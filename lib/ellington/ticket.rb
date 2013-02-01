require "digest"
require "delegate"

module Ellington

  class Ticket < SimpleDelegator
    attr_reader :passenger, :goal

    def initialize(goal=nil, hash={})
      @goal = goal || Ellington::Goal.new
      super hash
    end

    def id
      Digest::SHA256.hexdigest values.map(&:to_s).join
    end

    def passenger=(value)
      raise Ellington::PassengerAlreadyAssignedToTicket unless passenger.nil?
      @passenger = value
    end

    def goal_achieved?
      goal.achieved? passenger
    end

  end

end

