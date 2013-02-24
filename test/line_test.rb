require_relative "test_helper"

class LineTest < MicroTest::Test

  before do
    @route = BasicMath.new
    @line = @route.lines.first
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0), @route)
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
    assert line.name == "Addition::BasicMath"
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
    assert @line.passed == ["PASS Add1000::Addition"]
  end

  test "state pass" do
    @passenger.current_state = @line.passed.first
    assert @line.state(@passenger) == "PASS"
  end

  test "failed" do
    assert @line.failed == [
      "PASS Add10::Addition",
      "FAIL Add10::Addition",
      "PASS Add100::Addition",
      "FAIL Add100::Addition",
      "FAIL Add1000::Addition"
    ]
  end

  test "state fail" do
    @passenger.current_state = @line.failed.first
    assert @line.state(@passenger) == "FAIL"
  end

  test "errored" do
    assert @line.errored == [
      "ERROR Add10::Addition", 
      "ERROR Add100::Addition", 
      "ERROR Add1000::Addition"
    ]
  end

  test "state error" do
    @passenger.current_state = @line.errored.first
    assert @line.state(@passenger) == "ERROR"
  end

end
