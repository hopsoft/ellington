class Foo < Ellington::Line
  stations << Foo.new("Rip")
  stations << Rap.new("Rap")
  stations << Raz.new("Raz")
  goal "Raz"
  connections :pass => Bar.new, :fail => nil
end
