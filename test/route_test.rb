require_relative "test_helper"

class RouteTest < MicroTest::Test

  test "lines on class" do
    assert ExampleRoute1.lines.length == 3
    assert ExampleRoute1.lines[0].is_a?(ExampleLine1)
    assert ExampleRoute1.lines[1].is_a?(ExampleLine2)
    assert ExampleRoute1.lines[2].is_a?(ExampleLine3)
  end

  test "lines on instance" do
    route = ExampleRoute1.new
    assert route.lines.length == 3
    assert route.lines[0].is_a?(ExampleLine1)
    assert route.lines[1].is_a?(ExampleLine2)
    assert route.lines[2].is_a?(ExampleLine3)
  end

  test "type of lines must be unique" do
    begin
      ExampleRoute1.lines << ExampleLine1.new
    rescue Ellington::ListAlreadyContainsType => e
    end
    assert !e.nil?
  end

  test "lines are assigned route" do
    ExampleRoute1.lines.each do |line|
      assert line.route == ExampleRoute1
    end
  end

  test "goal" do
    assert ExampleRoute1.goal == [ExampleRoute1.lines[1].goal, ExampleRoute1.lines[2].goal].flatten
  end

  test "fault" do
    assert !ExampleRoute1.fault.empty?
    assert((ExampleRoute1.fault & ExampleRoute1.goal).empty?)
  end

end
