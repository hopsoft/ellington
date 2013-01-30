module Ellington
  class InvalidStateTransition < StandardError
  end

  class StateTransitionLimitExceeded < StandardError
  end

  class NotImplementedError < StandardError
  end
end
