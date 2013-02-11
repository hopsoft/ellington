require_relative "test_helper"

class RouteTest < MicroTest::Test

  class ExampleLine1 < Ellington::Line
  end

  class ExampleLine2 < Ellington::Line
  end

  class ExampleLine3 < Ellington::Line
  end

  class ExampleRoute < Ellington::Route
    lines << ExampleLine1.new
    lines << ExampleLine2.new
    lines << ExampleLine3.new
  end

  test "lines on class" do
    assert ExampleRoute.lines.length == 3
    assert ExampleRoute.lines[0].is_a?(ExampleLine1)
    assert ExampleRoute.lines[1].is_a?(ExampleLine2)
    assert ExampleRoute.lines[2].is_a?(ExampleLine3)
  end

  test "lines on instance" do
    route = ExampleRoute.new
    assert route.lines.length == 3
    assert route.lines[0].is_a?(ExampleLine1)
    assert route.lines[1].is_a?(ExampleLine2)
    assert route.lines[2].is_a?(ExampleLine3)
  end

  test "type of lines must be unique" do
    begin
      ExampleRoute.lines << ExampleLine1.new
    rescue Ellington::ListAlreadyContainsType => e
    end
    assert !e.nil?
  end

  test "lines are assigned route" do
    ExampleRoute.lines.each do |line|
      assert line.route == ExampleRoute
    end
  end

end
