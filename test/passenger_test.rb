require_relative "test_helper"

class PassengerTest < MicroTest::Test

  before do
    states = StateJacket::Catalog.new
    states.add :happy => [:sad, :error]
    states.add :sad => [:happy, :error]
    states.add :error
    states.lock
    ticket = Ellington::Ticket.new(:ok => true)
    @passenger = Ellington::Passenger.new({}, ticket, states)
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
    watcher.attrs(:info)
    watcher.def(:update) do |info|
      self.info = info 
    end

    @passenger.add_observer(watcher)
    @passenger.lock
    @passenger.current_state = :happy
    @passenger.transition_to :sad
    @passenger.unlock

    assert watcher.info.passenger == @passenger
    assert watcher.info.old_state == :happy
    assert watcher.info.new_state == :sad
  end

  test "states get locked on construction" do
    states = StateJacket::Catalog.new
    states.add :open => [:closed]
    states.add :closed => [:open]
    assert !states.frozen?
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new(:ok => true), states)
    assert states.frozen?
  end

  test "states get locked on construction and raise error if invalid" do
    states = StateJacket::Catalog.new
    states.add :open => [:closed]
    assert !states.frozen?
    error = nil
    begin
      passenger = Ellington::Passenger.new({}, states)
    rescue Exception => e
      error = e
    end
    assert !error.nil?
  end

end
