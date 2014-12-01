require_relative "test_helper"

class AttendantTest < PryTest::Test

  before do
    route = BasicMath.new
    line = route.lines.first
    @station = line.stations.first
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0), route)
    @passenger.current_state = route.initial_state
    @attendant = Ellington::Attendant.new(@station)
    @passenger.add_observer @attendant
  end

  test "passenger transition is captured" do
    @passenger.transition_to @station.passed
    assert @attendant.passenger_transitions.length == 1
  end

  test "approves of single passenger transition" do
    @passenger.transition_to @station.passed
    assert @attendant.approve?
  end

  test "multiple passenger transitions are captured" do
    @passenger.transition_to @station.errored
    @passenger.transition_to @station.passed
    assert @attendant.passenger_transitions.length == 2
  end

  test "disapproves of multiple passenger transitions" do
    @passenger.transition_to @station.errored
    @passenger.transition_to @station.passed
    assert !@attendant.approve?
  end

  test "a transition must be made in order to be approved" do
    assert !@attendant.approve?
  end

end
