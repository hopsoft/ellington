require_relative "test_helper"

class RouteTest < MicroTest::Test

  before do
    @route = BasicMath.new
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

end
