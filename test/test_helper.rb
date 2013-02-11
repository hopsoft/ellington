require_relative "../lib/ellington"

# stations -----------------------------------------------------------------
class ExampleStation1 < Ellington::Station
end

class ExampleStation2 < Ellington::Station
end

class ExampleStation3 < Ellington::Station
end

class ExampleStation4 < Ellington::Station
end

class ExampleStation5 < Ellington::Station
end

class ExampleStation6 < Ellington::Station
end

class ExampleStation7 < Ellington::Station
end

class ExampleStation8 < Ellington::Station
end

class ExampleStation9 < Ellington::Station
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

  goal line_two.goal, line_three.goal

  #connect_to line_two, :on => line_one.goal
  #connect_to line_three, :on => line_one.fault
end

