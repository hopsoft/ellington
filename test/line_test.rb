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
    @line.add_station station
    assert @line.stations.length == 1
    assert @line.stations.include?(station)
    assert station.line == @line
  end

  test "add multiple stations" do
    station1 = Ellington::Station.new("Station 1", :one, :two, :three)
    station2 = Ellington::Station.new("Station 2", :one, :two, :three)
    station3 = Ellington::Station.new("Station 3", :one, :two, :three)
    @line.add_station station1
    @line.add_station station2
    @line.add_station station3
    assert @line.stations.length == 3
    assert @line.stations.include?(station1)
    assert @line.stations.include?(station2)
    assert @line.stations.include?(station3)
    assert station1.line == @line
    assert station2.line == @line
    assert station3.line == @line
  end

  test "unable to add the same station more than once" do
    station = Ellington::Station.new("Station 1", :one, :two, :three)
    error = nil
    begin
      @line.add_station station
      @line.add_station station
    rescue Ellington::LineAlreadyAssignedToStation => e
      error = e
    end
    assert !error.nil?
  end

end
