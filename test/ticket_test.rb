require_relative "test_helper"
require "digest"

class TicketTest < PryTest::Test

  before do
    @route = BasicMath.new
    @ticket = Ellington::Ticket.new(Ellington::Target.new(:closed),
      :user_id => "458e9710-c1c4-495b-b25a-c622e893f6f7",
      :debit_id => "b834fb69-2eb3-4e57-b313-16b863e91f74",
      :credit_id => "9a670fce-4826-4a90-aaf7-a58738a4ce5b"
    )
    @passenger = Ellington::Passenger.new(0, @route, :ticket => @ticket)
  end

  test "basic ticket" do
    assert @ticket[:user_id] == "458e9710-c1c4-495b-b25a-c622e893f6f7"
    assert @ticket[:debit_id] == "b834fb69-2eb3-4e57-b313-16b863e91f74"
    assert @ticket[:credit_id] == "9a670fce-4826-4a90-aaf7-a58738a4ce5b"
  end

  test "ticket id" do
    assert @ticket.id == Digest::SHA256.hexdigest(@ticket.values.map(&:to_s).join)
  end

  test "goal" do
    assert @ticket.goal.to_a == [:closed]
  end

  test "goal is not achieved when passenger is not in the correct state" do
    assert !@ticket.goal.satisfied?(@passenger)
  end

  test "goal is achieved when passenger is in the correct state" do
    @passenger.current_state = :closed
    assert @ticket.goal.satisfied?(@passenger)
  end

end
