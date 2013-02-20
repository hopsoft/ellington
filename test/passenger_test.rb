require_relative "test_helper"

class PassengerTest < MicroTest::Test

  before do
    @route = BasicMath.new
    @number = NumberWithHistory.new(0)
    @passenger = Ellington::Passenger.new(@number, @route)
  end

  test "lock" do
    @passenger.lock
    assert @passenger.locked?
  end

  test "unlock" do
    @passenger.lock
    @passenger.unlock
    assert !@passenger.locked?
  end

  test "transition_to fails when unlocked" do
    error = nil
    begin
      @passenger.current_state = @route.initial_state
      @passenger.transition_to @route.lines.first.states.keys.first
    rescue Ellington::InvalidStateTransition => e
      error = e
    end
    assert !error.nil?
    assert error.message == "Cannot transition an unlocked Ellington::Passenger's state"
  end

  test "transition_to valid state" do
    @passenger.lock
    @passenger.current_state = @route.initial_state
    @passenger.transition_to @route.lines.first.states.keys.first
    @passenger.unlock
    assert @passenger.current_state == @route.lines.first.states.keys.first
  end

  test "transition_to invalid state" do
    error = nil
    begin
      @passenger.lock
      @passenger.current_state = :error
      @passenger.transition_to :happy
    rescue Ellington::InvalidStateTransition => e
      error = e
    end
    assert !error.nil?
    assert error.message == "Cannot transition Ellington::Passenger from:error to:happy"
  end

  test "observers are notified on transition" do
    watcher = MicroMock.make.new
    watcher.attrs(:info)
    watcher.def(:update) do |info|
      self.info = info 
    end

    @passenger.add_observer(watcher)
    @passenger.lock
    @passenger.current_state = @route.initial_state
    @passenger.transition_to @route.lines.first.states.keys.first
    @passenger.unlock

    assert watcher.info.passenger == @passenger
    assert watcher.info.old_state == "PRE BasicMath"
    assert watcher.info.new_state == "PASS Add10::Addition"
  end

  test "state_history" do
    @passenger.lock
    @passenger.current_state = @route.initial_state
    @passenger.transition_to @route.lines[0].states.keys.first
    @passenger.transition_to @route.lines[2].states.keys.first
    @passenger.unlock
    assert @passenger.state_history == ["PASS Add10::Addition", "PASS MultiplyBy10::Multiplication"]
  end

end
