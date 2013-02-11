require_relative "test_helper"

class LineTest < MicroTest::Test

  test "stations on class" do
    assert ExampleLine1.stations.length == 3
    assert ExampleLine1.stations[0].is_a?(ExampleStation1)
    assert ExampleLine1.stations[1].is_a?(ExampleStation2)
    assert ExampleLine1.stations[2].is_a?(ExampleStation3)
  end

  test "lines on instance" do
    line = ExampleLine1.new
    assert line.stations.length == 3
    assert line.stations[0].is_a?(ExampleStation1)
    assert line.stations[1].is_a?(ExampleStation2)
    assert line.stations[2].is_a?(ExampleStation3)
  end

  test "type of stations must be unique" do
    begin
      ExampleLine1.stations << ExampleStation1.new
    rescue Ellington::ListAlreadyContainsType => e
    end
    assert !e.nil?
  end

  test "stations are assigned line" do
    ExampleLine1.stations.each do |station|
      assert station.line == ExampleLine1
    end
  end

  test "full_name" do
    line = ExampleRoute1.lines.first
    assert line.full_name == "ExampleLine1 > ExampleRoute1"
  end

  test "formula" do
    line = ExampleRoute1.lines.first
    assert line.formula.steps[0].last == line.stations[0]
    assert line.formula.steps[1].last == line.stations[1]
    assert line.formula.steps[2].last == line.stations[2]
  end

  test "station1 'PASS' can transition to all station2 states" do
    line = ExampleRoute1.lines.first
    pass = line.stations[0].state_name(:pass)
    transitions = line.states[pass]
    assert transitions.include?(line.stations[1].state_name(:pass))
    assert transitions.include?(line.stations[1].state_name(:fail))
    assert transitions.include?(line.stations[1].state_name(:error))
  end

  test "station2 'PASS' can transition to all station3 states" do
    line = ExampleRoute1.lines.first
    pass = line.stations[1].state_name(:pass)
    transitions = line.states[pass]
    assert transitions.include?(line.stations[2].state_name(:pass))
    assert transitions.include?(line.stations[2].state_name(:fail))
    assert transitions.include?(line.stations[2].state_name(:error))
  end

  test "station3 'PASS' is terminal" do
    line = ExampleRoute1.lines.first
    pass = line.stations[2].state_name(:pass)
    transitions = line.states[pass]
    assert transitions.nil?
  end

  test "station3 'FAIL' is terminal" do
    line = ExampleRoute1.lines.first
    pass = line.stations[2].state_name(:fail)
    transitions = line.states[pass]
    assert transitions.nil?
  end

  test "goal" do
    line = ExampleRoute1.lines.first
    assert line.goal == [line.stations[2].passed]
  end

  test "fault" do
    line = ExampleRoute1.lines.first
    assert line.fault == line.states.keys - line.goal
  end

end
