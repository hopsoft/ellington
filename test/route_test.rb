require_relative "test_helper"

class RouteTest < MicroTest::Test

  before do
    @route = BasicMath.new
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0), @route)
  end

  test "must declare lines" do
    class NoLinesRoute < Ellington::Route
    end
    begin
      NoLinesRoute.new
    rescue Ellington::NoLinesDeclared => e
    end
    assert !e.nil?
  end

  test "must declare goal" do
    class NoGoalRoute < Ellington::Route
      lines << Addition.new
    end
    begin
      NoGoalRoute.new
    rescue Ellington::NoGoalDeclared => e
    end
    assert !e.nil?
  end

  test "lines on class" do
    assert @route.lines.length == 3
    assert @route.lines[0].is_a?(Addition)
    assert @route.lines[1].is_a?(Division)
    assert @route.lines[2].is_a?(Multiplication)
  end

  test "type of lines must be unique" do
    begin
      @route.lines << Addition.new
    rescue Ellington::ListAlreadyContainsType => e
    end
    assert !e.nil?
  end

  test "lines are assigned route" do
    @route.lines.each do |line|
      assert line.route == BasicMath
    end
  end

  test "goal" do
    goals = @route.goal & [@route.lines[1].goal, @route.lines[2].goal].flatten
    assert @route.goal.length == goals.length
  end

  test "fail_target" do
    assert !@route.fail_target.empty?
    assert((@route.fail_target & @route.pass_target).empty?)
    expected = (@route.states.keys - @route.pass_target).delete_if do |state|
      state.to_s =~ /\AERROR/
    end
    assert @route.fail_target == expected
  end

  test "connections" do
    assert @route.connections.first.line == @route.lines[1]
    assert @route.connections.first.states == @route.lines[0].pass_target
    assert @route.connections.last.line == @route.lines[2]
    assert @route.connections.last.states == @route.lines[0].fail_target
  end

  test "passed" do
    assert @route.passed == [
      "PASS DivideBy1000::Division", 
      "PASS MultiplyBy1000::Multiplication"
    ]
  end

  test "state pass" do
    @passenger.current_state = @route.passed.first
    assert @route.state(@passenger) == "PASS"
  end

  test "failed" do
    assert @route.failed == [
      "PRE BasicMath",
      "PASS Add10::Addition",
      "FAIL Add10::Addition",
      "PASS Add100::Addition",
      "FAIL Add100::Addition",
      "PASS Add1000::Addition",
      "FAIL Add1000::Addition",
      "PASS DivideBy10::Division",
      "FAIL DivideBy10::Division",
      "PASS DivideBy100::Division",
      "FAIL DivideBy100::Division",
      "FAIL DivideBy1000::Division",
      "PASS MultiplyBy10::Multiplication",
      "FAIL MultiplyBy10::Multiplication",
      "PASS MultiplyBy100::Multiplication",
      "FAIL MultiplyBy100::Multiplication",
      "FAIL MultiplyBy1000::Multiplication"
    ]
  end

  test "state fail" do
    @passenger.current_state = @route.failed.first
    assert @route.state(@passenger) == "FAIL"
  end

  test "errored" do
    assert @route.errored == [
      "ERROR Add10::Addition",
      "ERROR Add100::Addition",
      "ERROR Add1000::Addition",
      "ERROR DivideBy10::Division",
      "ERROR DivideBy100::Division",
      "ERROR DivideBy1000::Division",
      "ERROR MultiplyBy10::Multiplication",
      "ERROR MultiplyBy100::Multiplication",
      "ERROR MultiplyBy1000::Multiplication"
    ]
  end

  test "state error" do
    @passenger.current_state = @route.errored.first
    assert @route.state(@passenger) == "ERROR"
  end

end
