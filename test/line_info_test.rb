require_relative "test_helper"

class LineInfoTest < MicroTest::Test

  before do
    @route = BasicMath.new
    @line = @route.lines.first
    @station = @line.stations.first
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0), @route)
    @options = { :foo => :bar }
    @transition_info = Ellington::TransitionInfo.new(@passenger, @route.initial_state, @station.passed)
    @station_info = Ellington::StationInfo.new(@station, @passenger, @transition_info, @options)
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

  test "options" do
    assert @line_info.options == @options
  end

  test "station_full_name" do
    assert @line_info.station_full_name == "Add10::Addition::BasicMath"
  end

  test "log_message" do
    assert @line_info.log_message == "[Add10::Addition::BasicMath] [original_value:0] [current_value:0]"
  end

  test "log_message with station_completed pass" do
    @passenger.current_state = @station.passed
    expected = "[STATION COMPLETED] [PASS] [Add10::Addition::BasicMath] [original_value:0] [current_value:0]"
    assert @line_info.log_message(:station_completed => true) == expected
  end

  test "log_message with station_completed fail" do
    @passenger.current_state = @station.failed
    expected = "[STATION COMPLETED] [FAIL] [Add10::Addition::BasicMath] [original_value:0] [current_value:0]"
    assert @line_info.log_message(:station_completed => true) == expected
  end

  test "log_message with station_completed error" do
    @passenger.current_state = @station.errored
    expected = "[STATION COMPLETED] [ERROR] [Add10::Addition::BasicMath] [original_value:0] [current_value:0]"
    assert @line_info.log_message(:station_completed => true) == expected
  end

  test "log_message with line_completed pass" do
    @passenger.current_state = @line.stations.last.passed
    expected = "[LINE COMPLETED] [PASS] [Add10::Addition::BasicMath] [original_value:0] [current_value:0]"
    assert @line_info.log_message(:line_completed => true) == expected
  end

  test "log_message with line_completed fail" do
    @passenger.current_state = @line.stations.last.failed
    expected = "[LINE COMPLETED] [FAIL] [Add10::Addition::BasicMath] [original_value:0] [current_value:0]"
    assert @line_info.log_message(:line_completed => true) == expected
  end

end
