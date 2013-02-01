require_relative "test_helper"

class AttendantTest < MicroTest::Test

  before do
    states = StateJacket::Catalog.new
    states.add :happy => [:sad, :error]
    states.add :sad => [:happy, :error]
    states.add :error
    states.lock
    @passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, states)
    @passenger.current_state = :happy
    @passenger.lock
    @attendant = Ellington::Attendant.new
    @passenger.add_observer @attendant
  end

  test "passenger transition is captured" do
    @passenger.transition_to :sad
    assert @attendant.passenger_transitions.length == 1
  end

  test "approves of single passenger transition" do
    @passenger.transition_to :sad
    @passenger.transition_to :happy
    assert !@attendant.approve?
  end

  test "multiple passenger transitions are captured" do
    @passenger.transition_to :sad
    @passenger.transition_to :happy
    assert @attendant.passenger_transitions.length == 2
  end

  test "disapproves of multiple passenger transitions" do
    @passenger.transition_to :sad
    @passenger.transition_to :happy
    assert !@attendant.approve?
  end

end
