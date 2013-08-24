require_relative "test_helper"

class ConductorTest < MicroTest::Test

  before do
    @route = BasicMath.new
    @conductor = Ellington::Conductor.new(@route)
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0), @route)
    @passenger.current_state = @route.initial_state
    @passenger.lock
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

  test "escort prevented when passenger is not locked" do
    @passenger.unlock
    @conductor.conduct(@passenger)
    assert @passenger.current_state == @route.initial_state
  end

end
