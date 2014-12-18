require_relative "test_helper"

class TransitionInfoTest < PryTest::Test

  before do
    @route = BasicMath.new
    @line = @route.lines.first
    @station = @line.stations.first
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0), route: @route)
    @transition_info = Ellington::TransitionInfo.new(@passenger, @route.initial_state, @station.passed)
  end

  test "passenger" do
    assert @transition_info.passenger == @passenger
  end

  test "old_state" do
    assert @transition_info.old_state == @route.initial_state
  end

  test "new_state" do
    assert @transition_info.new_state == @station.passed
  end

end
