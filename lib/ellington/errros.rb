module Ellington
  class InvalidStates < StandardError
  end

  class InvalidStateTransition < StandardError
  end

  class StateTransitionLimitExceeded < StandardError
  end

  class NotImplementedError < StandardError
  end

  class LineAlreadyAssignedToStation < StandardError
  end

  class LineAlreadyBelongsToRoute < StandardError
  end
end
