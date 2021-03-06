require_relative "test_helper"

class RouteInfoTest < PryTest::Test

  before do
    @route = BasicMath.new
    @line = @route.lines.first
    @station = @line.stations.first
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0))
    @passenger.current_state = @route.lines.last.passed.first
    @transition_info = Ellington::TransitionInfo.new(@passenger, @route.initial_state, @station.passed)
    @station_info = Ellington::StationInfo.new(@station, @passenger, @transition_info)
    @line_info = Ellington::LineInfo.new(@line, @station_info)
    @route_info = Ellington::RouteInfo.new(@route, @line_info)
  end

  test "route" do
    assert @route_info.route == @route
  end

  test "line" do
    assert @route_info.line == @line
  end

  test "line_info" do
    assert @route_info.line_info == @line_info
  end

  test "station_info" do
    assert @route_info.station_info == @station_info
  end

  test "station" do
    assert @route_info.station == @station
  end

  test "passenger" do
    assert @route_info.passenger == @passenger
  end

  test "transition" do
    assert @route_info.transition == @transition_info
  end

  test "station_full_name" do
    assert @route_info.station_full_name == "BasicMath Addition Add10"
  end

  test "route_completed_message route pass" do
    assert @route_info.route_completed_message == "[ROUTE COMPLETED] [PASS] [BasicMath] [original_value:0] [current_value:0]"
  end

  test "route_completed_message route fail" do
    @passenger.current_state = @station.failed
    assert @route_info.route_completed_message == "[ROUTE COMPLETED] [FAIL] [BasicMath] [original_value:0] [current_value:0]"
  end

end
