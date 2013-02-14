require "digest"
require "delegate"

module Ellington

  class Ticket < SimpleDelegator
    attr_reader :passenger, :goal

    def initialize(goal=nil, hash={})
      goal ||= Ellington::Target.new
      @goal = goal
      super hash
    end

    def id
      Digest::SHA256.hexdigest values.map(&:to_s).join
    end

  end

end

