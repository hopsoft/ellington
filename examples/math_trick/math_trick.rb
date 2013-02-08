require_relative "initializer"
ticket_goal = Ellington::Goal.new(:add_pass)

# manually put passengers on the route
conductor = MathTrick::Conductor.new(MathTrick.route)
[631, 531, 955, 123].each do |number|
  puts "\n\n"
  ticket = Ellington::Ticket.new(ticket_goal)
  passenger = Ellington::Passenger.new(number, ticket, MathTrick.route.states)
  passenger.current_state = :new_number
  conductor.escort passenger
end
