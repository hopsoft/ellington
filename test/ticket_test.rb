require_relative "test_helper"
require "digest"

class TicketTest < MicroTest::Test

  before do
    @ticket = Ellington::Ticket.new([:closed], 
      :user_id => "458e9710-c1c4-495b-b25a-c622e893f6f7",
      :debit_id => "b834fb69-2eb3-4e57-b313-16b863e91f74",
      :credit_id => "9a670fce-4826-4a90-aaf7-a58738a4ce5b"
    )
  end

  test "basic ticket" do
    assert @ticket[:user_id] == "458e9710-c1c4-495b-b25a-c622e893f6f7"
    assert @ticket[:debit_id] == "b834fb69-2eb3-4e57-b313-16b863e91f74"
    assert @ticket[:credit_id] == "9a670fce-4826-4a90-aaf7-a58738a4ce5b"
  end

  test "ticket id" do
    assert @ticket.id == Digest::SHA256.hexdigest(@ticket.values.map(&:to_s).join)
  end

  test "passenger assignment" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    @ticket.passenger = passenger
    assert @ticket.passenger == passenger
  end

  test "passenger assignment is only allowed once" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    error = nil
    begin
      @ticket.passenger = passenger
      @ticket.passenger = passenger
    rescue Ellington::PassengerAlreadyAssignedToTicket => e
      error = e
    end
    assert !error.nil?
  end

  test "goal is not achieved when no passenger assigned" do
    assert !@ticket.goal_achieved?
  end

  test "goal is not achieved when passenger is not in the correct state" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    passenger.current_state = :open
    @ticket.passenger = passenger
    assert !@ticket.goal_achieved?
  end

  test "goal is achieved when passenger is in the correct state" do
    passenger = Ellington::Passenger.new({}, Ellington::Ticket.new, StateJacket::Catalog.new)
    passenger.current_state = :closed
    @ticket.passenger = passenger
    assert @ticket.goal_achieved?
  end

end
