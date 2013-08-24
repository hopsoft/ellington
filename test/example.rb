require "logger"
require_relative "../lib/ellington"

#require "yell"
#Ellington.logger = Yell.new do |logger|
#  logger.adapter STDOUT, :level => [:info], :format => "%m"
#end
#Ellington.logger = Logger.new($stdout)

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
  def engage(number, options)
    raise if rand(100) == 0
    if rand(100) > 5
      number.calc :+, 10
      pass_passenger number
    else
      fail_passenger number
    end
  rescue
    error_passenger number
  end
end

class Add100 < Ellington::Station
  def engage(number, options)
    raise if rand(100) == 0
    if rand(100) > 5
      number.calc :+, 100
      pass_passenger number
    else
      fail_passenger number
    end
  rescue
    error_passenger number
  end
end

class Add1000 < Ellington::Station
  def engage(number, options)
    raise if rand(100) == 0
    if rand(100) > 5
      number.calc :+, 1000
      pass_passenger number
    else
      fail_passenger number
    end
  rescue
    error_passenger number
  end
end

class MultiplyBy10 < Ellington::Station
  def engage(number, options)
    raise if rand(100) == 0
    if rand(100) > 5
      number.calc :*, 10
      pass_passenger number
    else
      fail_passenger number
    end
  rescue
    error_passenger number
  end
end

class MultiplyBy100 < Ellington::Station
  def engage(number, options)
    raise if rand(100) == 0
    if rand(100) > 5
      number.calc :*, 100
      pass_passenger number
    else
      fail_passenger number
    end
  rescue
    error_passenger number
  end
end

class MultiplyBy1000 < Ellington::Station
  def engage(number, options)
    raise if rand(100) == 0
    if rand(100) > 5
      number.calc :*, 1000
      pass_passenger number
    else
      fail_passenger number
    end
  rescue
    error_passenger number
  end
end

class DivideBy10 < Ellington::Station
  def engage(number, options)
    raise if rand(100) == 0
    if rand(100) > 5
      number.calc :/, 10.0
      pass_passenger number
    else
      fail_passenger number
    end
  rescue
    error_passenger number
  end
end

class DivideBy100 < Ellington::Station
  def engage(number, options)
    raise if rand(100) == 0
    if rand(100) > 5
      number.calc :/, 100.0
      pass_passenger number
    else
      fail_passenger number
    end
  rescue
    error_passenger number
  end
end

class DivideBy1000 < Ellington::Station
  def engage(number, options)
    raise if rand(100) == 0
    if rand(100) > 5
      number.calc :/, 1000.0
      pass_passenger number
    else
      fail_passenger number
    end
  rescue
    error_passenger number
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
  lines << division
  lines << multiplication

  goal division.passed, multiplication.passed

  connect_to division, :if_any => addition.passed
  connect_to multiplication, :if_any => addition.failed

  log_options :passenger => [:original_value, :current_value]
end

