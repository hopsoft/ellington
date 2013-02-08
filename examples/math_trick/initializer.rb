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

require "logger"
require_relative "../../lib/ellington"
require_relative "states"
require_relative "conductor"
stations_path = File.expand_path("stations", File.dirname(__FILE__))
Dir[File.join(stations_path, "*.rb")].each { |station| require station }
Ellington.logger = Logger.new($stdout)

module MathTrick
  def self.route
    @route ||= begin
      route_goal = Ellington::Goal.new(:add_pass)
      line_goal = Ellington::Goal.new(:add_pass)
      route = Ellington::Route.new('Math Trick', MathTrick::States, route_goal)
      line = Ellington::Line.new('Get to 1089', line_goal)
      line << MathTrick::FirstReverseStation.new
      line << MathTrick::SubtractStation.new
      line << MathTrick::SecondReverseStation.new
      line << MathTrick::AddStation.new
      route.add line
      route
   end
  end
end

