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

require "yell"
require "securerandom"
require_relative "loader"

Ellington.logger = Yell.new do |logger|
  logger.adapter STDOUT, :level => [:info], :format => "%m"
end

route = MathTrick.new
conductor = Ellington::Conductor.new(route)

while true
  sleep 1 # mock latency

  (0..10).map do
    # a number will serve as passenger
    number = rand(1000)

    # turn the number into a passenger
    # this is akin to putting a travel suit on
    passenger = Ellington::Passenger.new(number, route)

    # prepare the passenger for travel
    passenger.current_state = route.initial_state

    # put the passenger on the train
    conductor.conduct passenger
  end
end

