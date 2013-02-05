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

goal = Ellington::Goal.new(:add_pass)

route = Ellington::Route.new('Math Trick', goal)
line = Ellington::Line.new('line1', goal)
line << MathTrick::FirstReverseStation.new
line << MathTrick::SubtractStation.new
line << MathTrick::SecondReverseStation.new
line << MathTrick::AddStation.new
route.add line

conductor = MathTrick::Conductor.new(route)

# some numbers to run through the math trick
numbers = [
  631,
  531,
  955,
  123 # will fail
]

numbers.each do |number|
  puts "\n\n"
  ticket = Ellington::Ticket.new(goal)
  passenger = Ellington::Passenger.new(number, ticket, conductor.states)
  passenger.current_state = :new_number
  conductor.escort passenger
end

