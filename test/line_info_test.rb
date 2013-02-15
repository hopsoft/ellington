require_relative "test_helper"

class LineInfoTest < MicroTest::Test

  before do
    route = BasicMath.new
    line = route.lines.first
    passenger = Ellington::Passenger.new(NumberWithHistory.new(0), route)
    options = { :foo => :bar }
    transition_info = Ellington::TransitionInfo.new(passenger, route.initial_state, line.stations.first.passed)
    station_info = Ellington::StationInfo.new(line.stations.first, passenger, transition_info, options)
    @line_info = Ellington::LineInfo.new(line, station_info)
  end

  test "station_full_name" do
    assert @line_info.station_full_name == "Add10::Addition::BasicMath"
  end

  test "log_message" do
    assert @line_info.log_message == "[Add10::Addition::BasicMath] [original_value:0] [current_value:0]"
  end

end
