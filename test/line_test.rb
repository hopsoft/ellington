require_relative "test_helper"

class LineTest < MicroTest::Test

  before do
    LineTest.send(:remove_const, :TestLine) if LineTest.const_defined?(:TestLine)
  end

  test "stuff" do
    class TestLine < EllingtonLine
      stations << 1
      stations << 2
      stations << 3
    end
  end


#  class Station < Ellington::Station
#    transitions_passenger_to :one, :two, :three
#  end
#
#  before do
#    @line = Ellington::Line.new("Example Line")
#  end
#
#  test "name" do
#    assert @line.name == "Example Line"
#  end
#
#  test "add 1 station" do
#    station = LineTest::Station.new("Station 1")
#    @line << station
#    assert @line.length == 1
#    assert @line.include?(station)
#    assert @line == station.line
#  end
#
#  test "add multiple stations" do
#    station1 = LineTest::Station.new("Station 1")
#    station2 = LineTest::Station.new("Station 2")
#    station3 = LineTest::Station.new("Station 3")
#    @line << station1
#    @line << station2
#    @line << station3
#    assert @line.length == 3
#    assert @line.include?(station1)
#    assert @line.include?(station2)
#    assert @line.include?(station3)
#    assert station1.line == @line
#    assert station2.line == @line
#    assert station3.line == @line
#  end
#
#  test "unable to add the same station more than once" do
#    station = LineTest::Station.new("Station 1")
#    error = nil
#    begin
#      @line << station
#      @line << station
#    rescue Ellington::StationAlreadyBelongsToLine => e
#      error = e
#    end
#    assert !error.nil?
#  end
#
#  test "assign route" do
#    route = Ellington::Route.new("Example Route", StateJacket::Catalog.new)
#    @line.route = route
#    assert @line.route == route
#  end
#
#  test "can't assign same route more than once" do
#    route1 = Ellington::Route.new("Example Route 1", StateJacket::Catalog.new)
#    route2 = Ellington::Route.new("Example Route 2", StateJacket::Catalog.new)
#    error = nil
#    begin
#      @line.route = route1
#      @line.route = route2
#    rescue Ellington::LineAlreadyBelongsToRoute => e
#      error = e
#    end
#    assert !error.nil?
#  end

end
