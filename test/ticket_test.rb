require "securerandom"
require_relative "test_helper"

class TicketTest < MicroTest::Test

  before do
    @TicketData = Struct.new(:user_id, :debit_id, :credit_id)
  end

  test "expected ticket" do
    ticket_data = @TicketData.new(
      "458e9710-c1c4-495b-b25a-c622e893f6f7",
      "b834fb69-2eb3-4e57-b313-16b863e91f74",
      "9a670fce-4826-4a90-aaf7-a58738a4ce5b"
    )
    ticket = Ellington::Ticket.new(ticket_data)
    assert ticket.user_id == ticket_data.user_id
    assert ticket.debit_id == ticket_data.debit_id
    assert ticket.credit_id == ticket_data.credit_id
  end

end
