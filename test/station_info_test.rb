require_relative "test_helper"

class StationInfoTest < PryTest::Test

  before do
    @route = BasicMath.new
    @line = @route.lines.first
    @station = @line.stations.first
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0), route: @route)
    @transition_info = Ellington::TransitionInfo.new(@passenger, @route.initial_state, @station.passed)
    @station_info = Ellington::StationInfo.new(@station, @passenger, @transition_info)
  end

  test "station" do
    assert @station_info.station == @station
  end

  test "passenger" do
    assert @station_info.passenger == @passenger
  end

  test "transition" do
    assert @station_info.transition == @transition_info
  end

end
