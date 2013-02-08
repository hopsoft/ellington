require "logger"
require_relative "../../lib/ellington"
require_relative "conductor"
stations_path = File.expand_path("stations", File.dirname(__FILE__))
Dir[File.join(stations_path, "*.rb")].each { |station| require station }

# Use ellington to model this process
#
# 0 - Pick any three digits number with decreasing digits (432 or 875) [This will be implicit, thus step #0]
# 1 - reverse the number you wrote in step #0
# 2 - Subtract the number obtained in step #1 from the number you wrote in step #0
# 3 - Reverse the number obtained in step #2
# 4 - Add the numbers found in step #2 and step #3
#
# You will get a result of 1089
# credit: http://www.basic-mathematics.com/number-trick-with-1089.html

Ellington.logger = Logger.new($stdout)

# configure the states & their transitions
states = StateJacket::Catalog.new
states.add :new_number => [:first_reverse_pass, :first_reverse_fail, :first_reverse_error]
states.add :first_reverse_fail
states.add :first_reverse_error
states.add :first_reverse_pass => [:subtract_pass, :subtract_fail, :subtract_error]
states.add :subtract_fail
states.add :subtract_error
states.add :subtract_pass => [:second_reverse_pass, :second_reverse_fail, :second_reverse_error]
states.add :second_reverse_fail
states.add :second_reverse_error
states.add :second_reverse_pass => [:add_pass, :add_fail, :add_error]
states.add :add_fail
states.add :add_error
states.add :add_pass

# setup the goals
ticket_goal = Ellington::Goal.new(:add_pass)
route_goal = Ellington::Goal.new(:add_pass)
line_goal = Ellington::Goal.new(:add_pass)

# configure the route
route = Ellington::Route.new('Math Trick', states, route_goal)
line = Ellington::Line.new('Get to 1089', line_goal)
line << MathTrick::FirstReverseStation.new
line << MathTrick::SubtractStation.new
line << MathTrick::SecondReverseStation.new
line << MathTrick::AddStation.new
route.add line

# -----------------------------------------------------------------------------------------------------

# manually put passengers on the route
conductor = MathTrick::Conductor.new(route)
[631, 531, 955, 123].each do |number|
  puts "\n\n"
  ticket = Ellington::Ticket.new(ticket_goal)
  passenger = Ellington::Passenger.new(number, ticket, route.states)
  passenger.current_state = :new_number
  conductor.escort passenger
end

