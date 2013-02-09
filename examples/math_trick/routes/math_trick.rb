class Example < Ellington::Route
  lines << Foo.new("Foo")
  lines << Bar.new("Bar")
  lines << Baz.new("Baz")

  goal "Bar", "Baz"
  transfers :pass => nil, :fail => OtherExample.new("Other")
end

class Foo < Ellington::Line
  stations << Rip.new("Rip")
  stations << Rap.new("Rap")
  stations << Raz.new("Raz")
  goal "Raz"
  connections :pass => route.lines["Bar"], :fail => nil
end

class Rip < Ellington::Station

  def engage(passenger)
    if true
      pass passenger
    else
      fail passenger
    end
  rescue
    error passenger
  end

end
