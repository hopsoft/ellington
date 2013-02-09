require_relative "../lib/ellington"

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

class ExampleLine1 < Ellington::Line
  stations << ExampleStation1.new
  stations << ExampleStation2.new
  stations << ExampleStation3.new
end

class ExampleLine2 < Ellington::Line
  stations << ExampleStation4.new
  stations << ExampleStation5.new
  stations << ExampleStation6.new
end

class ExampleLine3 < Ellington::Line
  stations << ExampleStation7.new
  stations << ExampleStation8.new
  stations << ExampleStation9.new
end

class ExampleRoute < Ellington::Route
  lines << ExampleLine1.new
  lines << ExampleLine2.new
  lines << ExampleLine3.new
end

binding.pry
