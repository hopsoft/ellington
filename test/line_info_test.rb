require_relative "test_helper"

class LineInfoTest < PryTest::Test

  before do
    @route = BasicMath.new
    @line = @route.lines.first
    @station = @line.stations.first
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0))
    @transition_info = Ellington::TransitionInfo.new(@passenger, @route.initial_state, @station.passed)
    @station_info = Ellington::StationInfo.new(@station, @passenger, @transition_info)
    @line_info = Ellington::LineInfo.new(@line, @station_info)
  end

  test "line" do
    assert @line_info.line == @line
  end

  test "station_info" do
    assert @line_info.station_info == @station_info
  end

  test "station" do
    assert @line_info.station == @station
  end

  test "passenger" do
    assert @line_info.passenger == @passenger
  end

  test "transition" do
    assert @line_info.transition == @transition_info
  end

  test "station_full_name" do
    assert @line_info.station_full_name == "BasicMath Addition Add10"
  end

  test "line_completed_message" do
    assert @line_info.line_completed_message == "[LINE COMPLETED] [] [BasicMath Addition] [original_value:0] [current_value:0]"
  end

  test "station_completed_message" do
    assert @line_info.station_completed_message == "[STATION COMPLETED] [] [BasicMath Addition Add10] [original_value:0] [current_value:0]"
  end

  test "station_completed_message with station_completed pass" do
    @passenger.current_state = @station.passed
    expected = "[STATION COMPLETED] [PASS] [BasicMath Addition Add10] [original_value:0] [current_value:0]"
    assert @line_info.station_completed_message == expected
  end

  test "station_completed_message with station_completed fail" do
    @passenger.current_state = @station.failed
    expected = "[STATION COMPLETED] [FAIL] [BasicMath Addition Add10] [original_value:0] [current_value:0]"
    assert @line_info.station_completed_message == expected
  end

  test "station_completed_message with station_completed error" do
    @passenger.current_state = @station.errored
    expected = "[STATION COMPLETED] [ERROR] [BasicMath Addition Add10] [original_value:0] [current_value:0]"
    assert @line_info.station_completed_message == expected
  end

  test "line_completed_message with line_completed pass" do
    @passenger.current_state = @line.stations.last.passed
    expected = "[LINE COMPLETED] [PASS] [BasicMath Addition] [original_value:0] [current_value:0]"
    assert @line_info.line_completed_message == expected
  end

  test "line_completed_message with line_completed fail" do
    @passenger.current_state = @line.stations.last.failed
    expected = "[LINE COMPLETED] [FAIL] [BasicMath Addition] [original_value:0] [current_value:0]"
    assert @line_info.line_completed_message == expected
  end

end
