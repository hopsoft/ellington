require "securerandom"
require_relative "test_helper"

class TicketTest < MicroTest::Test

  before do
    @TicketInfo = Struct.new(:some_attr, :another_attr)
  end

  test "expected ticket" do
    ticket_info = @TicketInfo.new(SecureRandom.uuid, SecureRandom.uuid)
    ticket = Ellington::Ticket.new(ticket_info)
    assert ticket.some_attr == ticket_info.some_attr
    assert ticket.another_attr == ticket_info.another_attr
  end

end
