require_relative "test_helper"

class LineTest < PryTest::Test

  before do
    @route = BasicMath.new
    @line = @route.lines.first
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0))
  end

  test "must declare stations" do
    class NoStationsLine < Ellington::Line
    end
    begin
      NoStationsLine.new
    rescue Ellington::NoStationsDeclared => e
    end
    assert !e.nil?
  end

  test "must declare goal" do
    class NoGoalLine < Ellington::Line
      stations << Add10.new
    end
    begin
      NoGoalLine.new
    rescue Ellington::NoGoalDeclared => e
    end
    assert !e.nil?
  end

  test "stations on class" do
    assert @line.stations.length == 3
    assert @line.stations[0].is_a?(Add10)
    assert @line.stations[1].is_a?(Add100)
    assert @line.stations[2].is_a?(Add1000)
  end

  test "lines on instance" do
    assert @line.stations.length == 3
    assert @line.stations[0].is_a?(Add10)
    assert @line.stations[1].is_a?(Add100)
    assert @line.stations[2].is_a?(Add1000)
  end

  test "type of stations must be unique" do
    begin
      @line.stations << Add10.new
    rescue Ellington::ListAlreadyContainsType => e
    end
    assert !e.nil?
  end

  test "stations are assigned line" do
    @line.stations.each do |station|
      assert station.line == @line
    end
  end

  test "name" do
    line = @route.lines.first
    assert line.name == "BasicMath Addition"
  end

  test "formula" do
    line = @route.lines.first
    assert line.formula.steps[0].last == line.stations[0]
    assert line.formula.steps[1].last == line.stations[1]
    assert line.formula.steps[2].last == line.stations[2]
  end

  test "station1 'PASS' can transition to all station2 states" do
    line = @route.lines.first
    pass = line.stations[0].state_name(:pass)
    transitions = line.states[pass]
    assert transitions.include?(line.stations[1].state_name(:pass))
    assert transitions.include?(line.stations[1].state_name(:fail))
    assert transitions.include?(line.stations[1].state_name(:error))
  end

  test "station2 'PASS' can transition to all station3 states" do
    line = @route.lines.first
    pass = line.stations[1].state_name(:pass)
    transitions = line.states[pass]
    assert transitions.include?(line.stations[2].state_name(:pass))
    assert transitions.include?(line.stations[2].state_name(:fail))
    assert transitions.include?(line.stations[2].state_name(:error))
  end

  test "station3 'PASS' is terminal" do
    line = @route.lines.first
    pass = line.stations[2].state_name(:pass)
    transitions = line.states[pass]
    assert transitions.nil?
  end

  test "station3 'FAIL' is terminal" do
    line = @route.lines.first
    pass = line.stations[2].state_name(:fail)
    transitions = line.states[pass]
    assert transitions.nil?
  end

  test "pass_target" do
    line = @route.lines.first
    assert line.goal == [line.stations[2].passed]
  end

  test "fail_target" do
    line = @route.lines.first
    expected = (line.states.keys - line.goal).delete_if do |state|
      state.to_s =~ /\AERROR/
    end
    assert line.fail_target == expected
  end

  test "passed" do
    assert @line.passed == ["PASS Addition Add1000"]
  end

  test "state pass" do
    @passenger.current_state = @line.passed.first
    assert @line.state(@passenger) == "PASS"
  end

  test "failed" do
    assert @line.failed == [
      "PASS Addition Add10",
      "FAIL Addition Add10",
      "PASS Addition Add100",
      "FAIL Addition Add100",
      "FAIL Addition Add1000"
    ]
  end

  test "state fail" do
    @passenger.current_state = @line.failed.first
    assert @line.state(@passenger) == "FAIL"
  end

  test "errored" do
    assert @line.errored == [
      "ERROR Addition Add10",
      "ERROR Addition Add100",
      "ERROR Addition Add1000"
    ]
  end

  test "state error" do
    @passenger.current_state = @line.errored.first
    assert @line.state(@passenger) == "ERROR"
  end

  test "find station by type" do
    station = @line.stations.find_by_type(Add100)
    assert station.is_a?(Add100)
  end

end
