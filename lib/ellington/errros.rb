module Ellington
  class InvalidStates < StandardError
  end

  class AttendandDisapproves < StandardError
  end

  class InvalidStateTransition < StandardError
  end

  class NotImplementedError < StandardError
  end

  class StationAlreadyBelongsToLine < StandardError
  end

  class LineAlreadyBelongsToRoute < StandardError
  end

  class PassengerAlreadyAssignedToTicket < StandardError
  end
end
