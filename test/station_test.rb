require_relative "test_helper"

class StationTest < PryTest::Test

  before do
    @route = BasicMath.new
    @line = @route.lines.first
    @station = @line.stations.first
    @passenger = Ellington::Passenger.new(NumberWithHistory.new(0), @route)
    @passenger.current_state = @route.initial_state
  end

  test "name" do
    assert @station.name == "Addition Add10"
  end

  test "state_name" do
    assert @station.state_name(:foo) == "FOO Addition Add10"
  end

  test "passed" do
    assert @station.passed == "PASS Addition Add10"
  end

  test "failed" do
    assert @station.failed == "FAIL Addition Add10"
  end

  test "errored" do
    assert @station.errored == "ERROR Addition Add10"
  end

  test "states keys" do
    assert @station.states.keys == [
      @station.passed,
      @station.failed,
      @station.errored
    ]
  end

  test "error state can transition to passed" do
    assert @station.states.can_transition?(@station.errored => @station.passed)
  end

  test "error state can transition to failed" do
    assert @station.states.can_transition?(@station.errored => @station.failed)
  end

  test "pass state is terminating" do
    assert @station.states[@station.passed].nil?
    assert !@station.states.can_transition?(@station.passed => @station.failed)
    assert !@station.states.can_transition?(@station.passed => @station.errored)
  end

  test "fail state is terminating" do
    assert @station.states[@station.failed].nil?
    assert !@station.states.can_transition?(@station.failed => @station.passed)
    assert !@station.states.can_transition?(@station.failed => @station.errored)
  end

  test "pass properly transitions passenger's state" do
    @passenger.current_state = @route.initial_state
    @station.pass_passenger @passenger
    assert @passenger.current_state == @station.passed
  end

  test "fail properly transitions passenger's state" do
    @passenger.current_state = @route.initial_state
    @station.fail_passenger @passenger
    assert @passenger.current_state == @station.failed
  end

  test "error properly transitions passenger's state" do
    @passenger.current_state = @route.initial_state
    @station.error_passenger @passenger
    assert @passenger.current_state == @station.errored
  end

  test "can_engage? returns true for the expected inital state" do
    @passenger.current_state = @route.initial_state
    assert @station.can_engage?(@passenger)
  end

  test "can_engage? returns false for unexpected inital states" do
    @passenger.current_state = @line.stations.last.passed
    assert !@station.can_engage?(@passenger)
    @passenger.current_state = :unexpected
    assert !@station.can_engage?(@passenger)
  end

  test "can_engage? returns false if the passed state exists in state_history" do
    @passenger.current_state = @station.passed
    assert !@station.can_engage?(@passenger)
  end

  test "engage" do
    @passenger.current_state = @route.initial_state
    @station.engage(@passenger, nil)
    assert @passenger.current_state != @route.initial_state
  end

  test "observers are notified after a station completes" do
    observer = Spoof.make.new
    observer.attr :callbacks, []
    observer.method :update do |info|
      callbacks << info
    end
    @station.add_observer observer
    @passenger.current_state = @route.initial_state
    @station.call(@passenger)
    assert observer.callbacks.length == 1
    info = observer.callbacks.first
    assert info.station == @station
    assert info.passenger == @passenger
    assert info.transition.old_state == @route.initial_state
    assert info.transition.new_state != @route.initial_state
  end

end
