# This example is loosely modeled after the actual A train in New York.
# http://en.wikipedia.org/wiki/A_(New_York_City_Subway_service)

line = Ellington::Line.new("IND Eighth Avenue Line")
line << InwoodStation.new("Inwood - 207th Street")
line << OneSixtyEigthStation.new("")

route = Ellington::Route.new("A Eighth Avenue Express")
route.add line
