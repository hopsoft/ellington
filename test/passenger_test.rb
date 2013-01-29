require_relative "test_helper"

class PassengerTest < MicroTest::Test

  before do
    states = StateJacket::Catalog.new
    states.add :happy => [:sad, :error]
    states.add :sad => [:happy, :error]
    states.add :error
    states.lock
    @passenger = Ellington::Passenger.new(nil, states)
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
      @passenger.current_state = :happy
      @passenger.transition_to :sad
    rescue Ellington::InvalidStateTransition => e
      error = e
    end
    assert !error.nil?
    assert error.message == "Cannot transition an unlocked Ellington::Passenger's state"
  end

  test "transition_to (valid 1)" do
    @passenger.lock
    @passenger.current_state = :happy
    @passenger.transition_to :sad
    @passenger.unlock
    assert @passenger.current_state == :sad
  end

  test "transition_to (valid 2)" do
    @passenger.lock
    @passenger.current_state = :sad
    @passenger.transition_to :happy
    @passenger.unlock
    assert @passenger.current_state == :happy
  end

  test "transition_to (invalid)" do
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
    watcher.attrs(:passenger, :old_state, :new_state)
    watcher.def(:update) do |p, o, n|
      self.passenger = p
      self.old_state = o
      self.new_state = n
    end

    @passenger.add_observer(watcher)
    @passenger.lock
    @passenger.current_state = :happy
    @passenger.transition_to :sad
    @passenger.unlock

    assert watcher.passenger == @passenger
    assert watcher.old_state == :happy
    assert watcher.new_state == :sad
  end

end
