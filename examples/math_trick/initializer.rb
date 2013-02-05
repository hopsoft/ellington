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
require_relative "conductor"
Dir[File.expand_path("stations", File.dirname(__FILE__)) + "/*.rb"].each { |f| puts f; require f }

Ellington.logger = Logger.new($stdout)

route = Ellington::Route.new('trick', Ellington::Goal.new(:step4_pass))
line = Ellington::Line.new('line1', Ellington::Goal.new(:step4_pass))
route.add(line)
line << MathTrick::FirstReverseStation.new
line << MathTrick::SubtractStation.new
line << MathTrick::SecondReverseStation.new
line << MathTrick::AddStation.new

conductor = MathTrick::Conductor.new(route, 0.1)
conductor.conduct

