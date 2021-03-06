require_relative "test_helper"

class ConnectionTest < PryTest::Test

  before do
    @route = BasicMath.new
    @line = @route.lines.first
    @connection = Ellington::Connection.new(@route.lines[1], @line.passed)
  end

  test "line" do
    assert @connection.line == @route.lines[1]
  end

  test "states" do
    assert @connection.states == @line.passed
  end

end
