require "logger"
require_relative "../lib/ellington"

#require "yell"
#Ellington.logger = Yell.new do |logger|
#  logger.adapter STDOUT, :level => [:info], :format => "[%d] [%L] [%h][%p][%t] %m"
#end
Ellington.logger = Logger.new($stdout)

class NumberWithHistory
  attr_reader :original_value, :current_value, :history
  def initialize(value)
    @original_value = value
    @current_value = value
    @history = []
  end

  def calc(operand, other)
    value = current_value
    @current_value = current_value.send(operand, other)
    history.push(:before => value, :after => current_value)
    current_value
  end
end

# stations -----------------------------------------------------------------
class Add10 < Ellington::Station
  def engage(passenger, options)
    raise if rand(100) == 0
    if rand(100) > 5
      passenger.calc :+, 10
      pass passenger
    else
      fail passenger
    end
  rescue
    error passenger
  end
end

class Add100 < Ellington::Station
  def engage(passenger, options)
    raise if rand(100) == 0
    if rand(100) > 5
      passenger.calc :+, 100
      pass passenger
    else
      fail passenger
    end
  rescue
    error passenger
  end
end

class Add1000 < Ellington::Station
  def engage(passenger, options)
    raise if rand(100) == 0
    if rand(100) > 5
      passenger.calc :+, 1000
      pass passenger
    else
      fail passenger
    end
  rescue
    error passenger
  end
end

class MultiplyBy10 < Ellington::Station
  def engage(passenger, options)
    raise if rand(100) == 0
    if rand(100) > 5
      passenger.calc :*, 10
      pass passenger
    else
      fail passenger
    end
  rescue
    error passenger
  end
end

class MultiplyBy100 < Ellington::Station
  def engage(passenger, options)
    raise if rand(100) == 0
    if rand(100) > 5
      passenger.calc :*, 100
      pass passenger
    else
      fail passenger
    end
  rescue
    error passenger
  end
end

class MultiplyBy1000 < Ellington::Station
  def engage(passenger, options)
    raise if rand(100) == 0
    if rand(100) > 5
      passenger.calc :*, 1000
      pass passenger
    else
      fail passenger
    end
  rescue
    error passenger
  end
end

class DivideBy10 < Ellington::Station
  def engage(passenger, options)
    raise if rand(100) == 0
    if rand(100) > 5
      passenger.calc :/, 10
      pass passenger
    else
      fail passenger
    end
  rescue
    error passenger
  end
end

class DivideBy100 < Ellington::Station
  def engage(passenger, options)
    raise if rand(100) == 0
    if rand(100) > 5
      passenger.calc :*, 100
      pass passenger
    else
      fail passenger
    end
  rescue
    error passenger
  end
end

class DivideBy1000 < Ellington::Station
  def engage(passenger, options)
    raise if rand(100) == 0
    if rand(100) > 5
      passenger.calc :*, 1000
      pass passenger
    else
      fail passenger
    end
  rescue
    error passenger
  end
end

# lines --------------------------------------------------------------------
class Addition < Ellington::Line
  stations << Add10.new
  stations << Add100.new
  stations << Add1000.new
  goal stations.last.passed
end

class Multiplication < Ellington::Line
  stations << MultiplyBy10.new
  stations << MultiplyBy100.new
  stations << MultiplyBy1000.new
  goal stations.last.passed
end

class Division < Ellington::Line
  stations << DivideBy10.new
  stations << DivideBy100.new
  stations << DivideBy1000.new
  goal stations.last.passed
end

# route -------------------------------------------------------------------
class BasicMath < Ellington::Route
  addition = Addition.new
  multiplication = Multiplication.new
  division = Division.new

  lines << addition
  lines << multiplication
  lines << division

  goal multiplication.passed, division.passed

  connect_to division, :if => addition.passed
  connect_to multiplication, :if => addition.failed

  log_passenger_attrs :current_value
end

# conductor ---------------------------------------------------------------
class NumberConductor < Ellington::Conductor

  def gather_passengers
    (0..999).to_a.sample(10).map do |num|
      num = NumberWithHistory.new(num)
      passenger = Ellington::Passenger.new(num, route)
      passenger.current_state = route.initial_state
      passenger.lock
      passenger
    end
  end

end

if ENV["START"]
  route = BasicMath.new
  conductor = NumberConductor.new(route)
  conductor.start
end
