require "digest"
require "delegate"

module Ellington

  class Ticket < SimpleDelegator
    attr_reader :passenger, :goal

    def initialize(goal=[], hash={})
      @goal = goal
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
      return false unless passenger
      goal.include? passenger.current_state
    end

  end

end

