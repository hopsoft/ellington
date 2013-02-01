require "delegate"

module Ellington

  # Simple wrapper around a ticket object.
  # NOTE: This may not be needed but it does preserve some options for the future.
  # @example
  #   TicketData = Struct.new(:user_id, :debit_id, :credit_id)
  #   ticket_data = TicketData.new(
  #     "458e9710-c1c4-495b-b25a-c622e893f6f7",
  #     "b834fb69-2eb3-4e57-b313-16b863e91f74",
  #     "9a670fce-4826-4a90-aaf7-a58738a4ce5b"
  #   )
  #   ticket = Ellington::Ticket.new(ticket_data)
  class Ticket < SimpleDelegator
    attr_reader :goal

    def initialize(context, goal=[])
      @goal = goal
      super context
    end

    def goal_achieved?(passenger)
      goal.include? passenger.current_state
    end

  end

end
