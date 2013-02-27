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
      @error_target ||= begin
        Ellington::Target.new states.keys - goal - fail_target
      end
    end
    alias_method :errored, :error_target

    def state_names(states)
      names = []
      names << "PASS" if (states & passed).length == passed.length
      names << "FAIL" if (states & failed).length == failed.length
      names << "ERROR" if (states & errored).length == errored.length
      names
    end

    def state(passenger)
      case
      when passed.satisfied?(passenger) then "PASS"
      when failed.satisfied?(passenger) then "FAIL"
      when errored.satisfied?(passenger) then "ERROR"
      else
        nil
      end
    end

  end
end
