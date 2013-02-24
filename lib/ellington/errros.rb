module Ellington
  class ListAlreadyContainsType < StandardError
  end

  class AttendantDisapproves < StandardError
  end

  class InvalidStateTransition < StandardError
  end

  class NotImplementedError < StandardError
  end

  class NoStationsDeclared < StandardError
  end

  class NoGoalDeclared < StandardError
  end
end
