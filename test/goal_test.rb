require_relative "test_helper"

class GoalTest < MicroTest::Test

  test "basic goal" do
    goal = Ellington::Goal.new(:finished)
    assert goal.include?(:finished)
  end

  test "multiple states" do
    goal = Ellington::Goal.new(:one, :two, :three)
    assert goal.include?(:one)
    assert goal.include?(:two)
    assert goal.include?(:three)
  end

  test "not achieved for nil passenger" do
    goal = Ellington::Goal.new(:finished)
    assert !goal.achieved?(nil)
  end

  test "not achieved for passenger in the wrong state" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    passenger.current_state = :open
    goal = Ellington::Goal.new(:closed)
    assert !goal.achieved?(passenger)
  end

  test "achieved for passenger in the right state" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    passenger.current_state = :closed
    goal = Ellington::Goal.new(:closed)
    assert goal.achieved?(passenger)
  end

  test "achieved for passenger in an expected state" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    passenger.current_state = :two
    goal = Ellington::Goal.new(:one, :two, :three)
    assert goal.achieved?(passenger)
  end

  test "not achieved for passenger not in an expected state" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    passenger.current_state = :four
    goal = Ellington::Goal.new(:one, :two, :three)
    assert !goal.achieved?(passenger)
  end

end
