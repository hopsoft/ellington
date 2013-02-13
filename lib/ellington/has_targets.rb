module Ellington
  module HasTargets

    def fail_target
      @non_goal_target ||= begin
        state_list = states.keys - goal
        state_list.reject! { |state| state.to_s =~ /\AERROR/ }
        Ellington::Target.new *state_list
      end
    end
    alias_method :failed, :fail_target

    def error_target
      @error_target ||= states.keys - goal - fail_target
    end
    alias_method :errored, :error_target

    def pass?(passenger)
      pass.satisfied? passenger
    end

    def fail?(flop, passenger)
      fail.satisfied? passenger
    end

    def error?(passenger)
      error.satisfied? passenger
    end

  end
end
