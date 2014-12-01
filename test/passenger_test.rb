require_relative "test_helper"

class PassengerTest < PryTest::Test

  before do
    @route = BasicMath.new
    @number = NumberWithHistory.new(0)
    @passenger = Ellington::Passenger.new(@number, @route)
  end

  test "construct with ticket option" do
    ticket = Ellington::Ticket.new
    passenger = Ellington::Passenger.new(@number, @route, :ticket => ticket)
    assert passenger.ticket == ticket
  end

  test "construct with state_history option" do
    passenger = Ellington::Passenger.new(@number, @route, :state_history => [:foo, :bar])
    assert passenger.state_history == [:foo, :bar]
  end

  test "transition_to valid state" do
    @passenger.current_state = @route.initial_state
    @passenger.transition_to @route.lines.first.states.keys.first
    assert @passenger.current_state == @route.lines.first.states.keys.first
  end

  test "transition_to invalid state" do
    error = nil
    begin
      @passenger.current_state = :error
      @passenger.transition_to :happy
    rescue Ellington::InvalidStateTransition => e
      error = e
    end
    assert !error.nil?
    assert error.message == "Cannot transition Ellington::Passenger from:error to:happy"
  end

  test "observers are notified on transition" do
    watcher = Spoof.make.new
    watcher.attrs(:info)
    watcher.method(:update) do |info|
      self.info = info
    end

    @passenger.add_observer(watcher)
    @passenger.current_state = @route.initial_state
    @passenger.transition_to @route.lines.first.states.keys.first

    assert watcher.info.passenger == @passenger
    assert watcher.info.old_state == "PRE BasicMath"
    assert watcher.info.new_state == "PASS Addition Add10"
  end

  test "state_history" do
    @passenger.current_state = @route.initial_state
    @passenger.transition_to @route.lines[0].states.keys.first
    @passenger.transition_to @route.lines[2].states.keys.first
    assert @passenger.state_history == ["PASS Addition Add10", "PASS Multiplication MultiplyBy10"]
  end

end
