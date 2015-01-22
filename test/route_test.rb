require_relative "test_helper"

class RouteTest < PryTest::Test

  before do
    @route = BasicMath.new
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0))
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
      "PASS Division DivideBy1000",
      "PASS Multiplication MultiplyBy1000"
    ]
  end

  test "state pass" do
    @passenger.current_state = @route.passed.first
    assert @route.state(@passenger) == "PASS"
  end

  test "failed" do
    assert @route.failed == [
      "PRE BasicMath",
      "PASS Addition Add10",
      "FAIL Addition Add10",
      "PASS Addition Add100",
      "FAIL Addition Add100",
      "PASS Addition Add1000",
      "FAIL Addition Add1000",
      "PASS Division DivideBy10",
      "FAIL Division DivideBy10",
      "PASS Division DivideBy100",
      "FAIL Division DivideBy100",
      "FAIL Division DivideBy1000",
      "PASS Multiplication MultiplyBy10",
      "FAIL Multiplication MultiplyBy10",
      "PASS Multiplication MultiplyBy100",
      "FAIL Multiplication MultiplyBy100",
      "FAIL Multiplication MultiplyBy1000"
    ]
  end

  test "state fail" do
    @passenger.current_state = @route.failed.first
    assert @route.state(@passenger) == "FAIL"
  end

  test "errored" do
    assert @route.errored == [
      "ERROR Addition Add10",
      "ERROR Addition Add100",
      "ERROR Addition Add1000",
      "ERROR Division DivideBy10",
      "ERROR Division DivideBy100",
      "ERROR Division DivideBy1000",
      "ERROR Multiplication MultiplyBy10",
      "ERROR Multiplication MultiplyBy100",
      "ERROR Multiplication MultiplyBy1000"
    ]

  end

  test "state error" do
    @passenger.current_state = @route.errored.first
    assert @route.state(@passenger) == "ERROR"
  end

  test "find line by type" do
    line = @route.lines.find_by_type(Division)
    assert line.is_a?(Division)
  end

end
