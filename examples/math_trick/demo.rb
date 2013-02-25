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

class MathTrickConductor < Ellington::Conductor

  def gather_passengers
    sleep 1 # wait a bit between batches
    (0..10).map do
      passenger = Ellington::Passenger.new(rand(1000), route)
      passenger.current_state = route.initial_state
      passenger.lock
      passenger
    end
  end

end

conductor = MathTrickConductor.new(MathTrick.new)
conductor.start
conductor.wait

