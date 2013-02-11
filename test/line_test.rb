require_relative "test_helper"

class LineTest < MicroTest::Test

  class ExampleStation1 < Ellington::Station
  end

  class ExampleStation2 < Ellington::Station
  end

  class ExampleStation3 < Ellington::Station
  end

  class ExampleLine < Ellington::Line
    stations << ExampleStation1.new
    stations << ExampleStation2.new
    stations << ExampleStation3.new
  end

  class ExampleRoute < Ellington::Route
    lines << ExampleLine.new
  end

  test "stations on class" do
    assert ExampleLine.stations.length == 3
    assert ExampleLine.stations[0].is_a?(ExampleStation1)
    assert ExampleLine.stations[1].is_a?(ExampleStation2)
    assert ExampleLine.stations[2].is_a?(ExampleStation3)
  end

  test "lines on instance" do
    line = ExampleLine.new
    assert line.stations.length == 3
    assert line.stations[0].is_a?(ExampleStation1)
    assert line.stations[1].is_a?(ExampleStation2)
    assert line.stations[2].is_a?(ExampleStation3)
  end

  test "type of stations must be unique" do
    begin
      ExampleLine.stations << ExampleStation1.new
    rescue Ellington::ListAlreadyContainsType => e
    end
    assert !e.nil?
  end

  test "stations are assigned line" do
    ExampleLine.stations.each do |station|
      assert station.line == ExampleLine
    end
  end

  test "full_name" do
    line = ExampleRoute.lines.first
    assert line.full_name == "LineTest::ExampleLine > LineTest::ExampleRoute"
  end

  test "formula" do
    line = ExampleRoute.lines.first
    assert line.formula.steps[0].last == line.stations[0]
    assert line.formula.steps[1].last == line.stations[1]
    assert line.formula.steps[2].last == line.stations[2]
  end

  test "states" do
    line = ExampleRoute.lines.first
    assert false
  end

end
