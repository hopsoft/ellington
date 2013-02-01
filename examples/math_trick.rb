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

require 'logger'
require_relative '../lib/ellington'

# some numbers to run through the math trick
$numbers = [
  631,
  531,
  955,
  123 # will fail
]

# create a list of all states with possible transistions defined
states = StateJacket::Catalog.new
states.add :new_number => [:step1_pass, :step1_fail, :step1_error]
states.add :step1_fail
states.add :step1_error
states.add :step1_pass => [:step2_pass, :step2_fail, :step2_error]
states.add :step2_fail
states.add :step2_error
states.add :step2_pass => [:step3_pass, :step3_fail, :step3_error]
states.add :step3_fail
states.add :step3_error
states.add :step3_pass => [:step4_pass, :step4_fail, :step4_error]
states.add :step4_fail
states.add :step4_error
states.add :step4_pass
$states = states


# define conductor class
class TrickConductor < Ellington::Conductor
  def verify(passenger)
    true
  end

  def gather_passengers
    num = $numbers.pop
    puts num
    if num
      goal = Ellington::Goal.new(:step4_pass)
      ticket = Ellington::Ticket.new(goal)
      passenger = Ellington::Passenger.new(num, ticket, $states)
      passenger.current_state = :new_number
      return [passenger]
    else
      @stop = true
    end
    return []
  end
end

# create route, a line and add the line to the route
route = Ellington::Route.new('trick', Ellington::Goal.new(:step4_pass))
line = Ellington::Line.new('line1', Ellington::Goal.new(:step4_pass))
route.add(line)


class Station1 < Ellington::Station
  def engage(passenger, options={})
    begin
      options[:first_reverse] = passenger.context.to_s.reverse.to_i
      passenger.transition_to(:step1_pass)
    rescue Exception
      passenger.transition_to(:step1_error)
    end
  end
end

class Station2 < Ellington::Station
  def engage(passenger, options={})
    begin
      options[:first_subtract] = passenger.context - options[:first_reverse]
      passenger.transition_to(:step2_pass)
    rescue Exception
      passenger.transition_to(:step2_error)
    end
  end
end

class Station3 < Ellington::Station
  def engage(passenger, options={})
    begin
      options[:second_reverse] = options[:first_subtract].to_s.reverse.to_i
      passenger.transition_to(:step3_pass)
    rescue Exception
      passenger.transition_to(:step3_error)
    end
  end
end

class Station4 < Ellington::Station
  def engage(passenger, options={})
    begin
      result = options[:first_subtract] + options[:second_reverse]
      if result == 1089
        passenger.transition_to(:step4_pass)
      else
        passenger.transition_to(:step4_fail)
      end
    rescue Exception
      passenger.transition_to(:step4_error)
    end
  end
end

line << Station1.new('station 1', [:step1_pass, :step1_fail, :step1_error])
line << Station2.new('station 2', [:step2_pass, :step2_fail, :step2_error])
line << Station3.new('station 3', [:step3_pass, :step3_fail, :step3_error])
line << Station4.new('station 4', [:step4_pass, :step4_fail, :step4_error])

Ellington.logger = Logger.new($stdout)

conductor = TrickConductor.new(route, 0.1)
conductor.conduct

