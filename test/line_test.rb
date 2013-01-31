require_relative "test_helper"

class LineTest < MicroTest::Test

  before do
    @line = Ellington::Line.new("Example Line")
  end

  test "name" do
    assert @line.name == "Example Line"
  end

  test "add 1 station" do
    station = Ellington::Station.new("Station 1", :one, :two, :three)
    @line << station
    assert @line.length == 1
    assert @line.include?(station)
    assert station.line == @line
  end

  test "add multiple stations" do
    station1 = Ellington::Station.new("Station 1", :one, :two, :three)
    station2 = Ellington::Station.new("Station 2", :one, :two, :three)
    station3 = Ellington::Station.new("Station 3", :one, :two, :three)
    @line << station1
    @line << station2
    @line << station3
    assert @line.length == 3
    assert @line.include?(station1)
    assert @line.include?(station2)
    assert @line.include?(station3)
    assert station1.line == @line
    assert station2.line == @line
    assert station3.line == @line
  end

  test "unable to add the same station more than once" do
    station = Ellington::Station.new("Station 1", :one, :two, :three)
    error = nil
    begin
      @line << station
      @line << station
    rescue Ellington::LineAlreadyAssignedToStation => e
      error = e
    end
    assert !error.nil?
  end

  test "assign route" do
    route = Ellington::Route.new("Example Route")
    @line.route = route
    assert @line.route == route
  end

  test "can't assign same route more than once" do
    route1 = Ellington::Route.new("Example Route 1")
    route2 = Ellington::Route.new("Example Route 2")
    error = nil
    begin
      @line.route = route1
      @line.route = route2
    rescue Ellington::RouteAlreadyAssignedToLine => e
      error = e
    end
    assert !error.nil?
  end

end
