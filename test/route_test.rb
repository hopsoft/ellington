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


































#  before do
#    @route = Ellington::Route.new("Example Route", StateJacket::Catalog.new)
#  end
#
#  test "name" do
#    assert @route.name == "Example Route"
#  end
#
#  test "add 1 line" do
#    line = Ellington::Line.new("Example Line")
#    @route.add line
#    assert @route.length == 1
#    assert @route[line.name] == line
#    assert @route == line.route
#  end
#
#  test "add multiple lines" do
#    line1 = Ellington::Line.new("Example Line 1")
#    line2 = Ellington::Line.new("Example Line 2")
#    line3 = Ellington::Line.new("Example Line 3")
#    @route.add line1
#    @route.add line2
#    @route.add line3
#    assert @route.length == 3
#    assert @route[line1.name] == line1
#    assert @route[line2.name] == line2
#    assert @route[line3.name] == line3
#    assert @route == line1.route
#    assert @route == line2.route
#    assert @route == line3.route
#  end
#
#  test "unable to add the same line more than once" do
#    line = Ellington::Line.new("Example Line")
#    error = nil
#    begin
#      @route.add line
#      @route.add line
#    rescue Ellington::LineAlreadyBelongsToRoute => e
#      error = e
#    end
#    assert !error.nil?
#  end
#
#  test "head is assigned properly after 1 line added" do
#    line = Ellington::Line.new("Example Line")
#    @route.add line
#    assert @route.head == line
#  end
#
#  test "head is assigned properly after multiple lines added" do
#    line1 = Ellington::Line.new("Example Line 1")
#    line2 = Ellington::Line.new("Example Line 2")
#    line3 = Ellington::Line.new("Example Line 3")
#    @route.add line1
#    @route.add line2
#    @route.add line3
#    assert @route.head == line1
#  end

end
