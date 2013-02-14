require "logger"
require "delegate"
require_relative "../lib/ellington"

require "yell"
Ellington.logger = Yell.new do |logger|
  logger.adapter STDOUT, :level => [:info], :format => "[%d] [%L] [%h][%p][%t] %m"
end
#Ellington.logger =  Logger.new($stdout)

class NumberWithHistory
  attr_reader :original_value, :current_value, :history
  def initialize(value)
    @original_value = value
    @current_value = value
    @history = []
  end

  def add(other)
    value = current_value
    @current_value = current_value + other
    history.push(:before => value, :after => current_value)
    current_value
  end
end

module AdditionStation
  def engage(passenger, options)
    raise if !options[:pass] && rand(99) == 1
    if options[:pass] || rand(99) >= 5
      passenger.add 1
      pass passenger
    else
      fail passenger
    end
  rescue Exception => e
    error passenger
  end
end

# stations -----------------------------------------------------------------
class ExampleStation1 < Ellington::Station
  include AdditionStation
end

class ExampleStation2 < Ellington::Station
  include AdditionStation
end

class ExampleStation3 < Ellington::Station
  include AdditionStation
end

class ExampleStation4 < Ellington::Station
  include AdditionStation
end

class ExampleStation5 < Ellington::Station
  include AdditionStation
end

class ExampleStation6 < Ellington::Station
  include AdditionStation
end

class ExampleStation7 < Ellington::Station
  include AdditionStation
end

class ExampleStation8 < Ellington::Station
  include AdditionStation
end

class ExampleStation9 < Ellington::Station
  include AdditionStation
end

# lines --------------------------------------------------------------------
class ExampleLine1 < Ellington::Line
  one = ExampleStation1.new
  two = ExampleStation2.new
  three = ExampleStation3.new
  stations << one
  stations << two
  stations << three
  goal three.passed
end

class ExampleLine2 < Ellington::Line
  four = ExampleStation4.new
  five = ExampleStation5.new
  six = ExampleStation6.new
  stations << four
  stations << five
  stations << six
  goal six.passed
end

class ExampleLine3 < Ellington::Line
  seven = ExampleStation7.new
  eight = ExampleStation8.new
  nine = ExampleStation9.new
  stations << seven
  stations << eight
  stations << nine
  goal nine.passed
end

# routes -------------------------------------------------------------------
class ExampleRoute1 < Ellington::Route
  line_one = ExampleLine1.new
  line_two = ExampleLine2.new
  line_three = ExampleLine3.new

  lines << line_one
  lines << line_two
  lines << line_three

  goal line_two.passed, line_three.passed

  connect_to line_two, :if => line_one.passed
  connect_to line_three, :if => line_one.failed

  log_passenger_attrs :current_value
end

num = NumberWithHistory.new 0
passenger = Ellington::Passenger.new(num, Ellington::Ticket.new, ExampleRoute1.states)
passenger.lock
passenger.current_state = ExampleRoute1.initial_state
ExampleRoute1.new.board passenger

