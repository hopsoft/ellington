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

require "securerandom"
require "logger"
require_relative "loader"

Ellington.logger = Logger.new(STDOUT)
route = MathTrick.new
conductor = Ellington::Conductor.new(route)

NumberWrapper = Struct.new(:value, :first_reverse, :first_subtract, :second_reverse, :result)

while true
  sleep 1 # mock latency

  (0..10).map do
    # a wrapped number will serve as passenger
    number = NumberWrapper.new(rand(1000))

    # put the passenger on the train
    conductor.conduct number
  end
end

