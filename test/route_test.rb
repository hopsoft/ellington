require_relative "test_helper"

class RouteTest < MicroTest::Test

  before do
    @route = Ellington::Route.new("Example Route")
  end

  test "name" do
    assert @route.name == "Example Route"
  end

  test "add 1 line" do
    line = Ellington::Line.new("Example Line")
    @route[line.name] = line
    assert @route.length == 1
    assert @route[line.name] == line
    assert @route == line.route
  end

  test "add multiple lines" do
    line1 = Ellington::Line.new("Example Line 1")
    line2 = Ellington::Line.new("Example Line 2")
    line3 = Ellington::Line.new("Example Line 3")
    @route[line1.name] = line1
    @route[line2.name] = line2
    @route[line3.name] = line3
    assert @route.length == 3
    assert @route[line1.name] == line1
    assert @route[line2.name] == line2
    assert @route[line3.name] == line3
    assert @route == line1.route
    assert @route == line2.route
    assert @route == line3.route
  end

  test "unable to add the same line more than once" do
    line = Ellington::Line.new("Example Line")
    error = nil
    begin
      @route[line.name] = line
      @route[line.name] = line
    rescue Ellington::LineAlreadyBelongsToRoute => e
      error = e
    end
    assert !error.nil?
  end

  test "head is assigned properly after 1 line added" do
    line = Ellington::Line.new("Example Line")
    @route[line.name] = line
    assert @route.head == line
  end

  test "head is assigned properly after multiple lines added" do
    line1 = Ellington::Line.new("Example Line 1")
    line2 = Ellington::Line.new("Example Line 2")
    line3 = Ellington::Line.new("Example Line 3")
    @route[line1.name] = line1
    @route[line2.name] = line2
    @route[line3.name] = line3
    assert @route.head == line1
  end

end
