require_relative "test_helper"

class ConductorTest < PryTest::Test

  before do
    @route = BasicMath.new
    @conductor = Ellington::Conductor.new(@route)
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0), @route)
    @passenger.current_state = @route.initial_state
  end

  test "verify" do
    assert @conductor.verify(@passenger)
  end

  test "conduct" do
    @conductor.conduct(@passenger)
    assert @passenger.current_state != @route.initial_state
  end

  test "conduct prevented when passenger doesn't verify" do
    def @conductor.verify(passenger)
      false
    end
    @conductor.conduct(@passenger)
    assert @passenger.current_state == @route.initial_state
  end

end
