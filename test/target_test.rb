require_relative "test_helper"

class TargetTest < MicroTest::Test

  test "basic goal" do
    goal = Ellington::Target.new(:finished)
    assert goal.include?(:finished)
  end

  test "multiple states" do
    goal = Ellington::Target.new(:one, :two, :three)
    assert goal.include?(:one)
    assert goal.include?(:two)
    assert goal.include?(:three)
  end

  test "not satisfied for nil passenger" do
    goal = Ellington::Target.new(:finished)
    assert !goal.satisfied?(nil)
  end

  test "not satisfied for passenger in the wrong state" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    passenger.current_state = :open
    goal = Ellington::Target.new(:closed)
    assert !goal.satisfied?(passenger)
  end

  test "satisfied for passenger in the right state" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    passenger.current_state = :closed
    goal = Ellington::Target.new(:closed)
    assert goal.satisfied?(passenger)
  end

  test "satisfied for passenger in an expected state" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    passenger.current_state = :two
    goal = Ellington::Target.new(:one, :two, :three)
    assert goal.satisfied?(passenger)
  end

  test "not satisfied for passenger not in an expected state" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    passenger.current_state = :four
    goal = Ellington::Target.new(:one, :two, :three)
    assert !goal.satisfied?(passenger)
  end

end
