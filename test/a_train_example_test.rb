require_relative "test_helper"

module ATrain

  class InwoodStation < Ellington::Station
    transitions_passenger_to :inwood_pass, :inwood_fail, :inwood_error

    def engage(passenger, options)
    end
  end

end


class FullExampleTest < MicroTest::Test

  # This test is loosely modeled after the actual A train in New York.
  # http://en.wikipedia.org/wiki/A_(New_York_City_Subway_service)
  test "setup the A train" do
    route = Ellington::Route.new("A Eighth Avenue Express")
    #route.add ATrain::InwoodStation.new("Inwood - 207th Street")
#
#    line = Ellington::Line.new(
#      "IND Eighth Avenue Line",
#      "Inwood - 207th Street" => "168th Street"
#    )
#    line.stations.add Ellington::Station.new("207th Street")
#    line.stations.add Ellington::Station.new("181st Street")
#    line.stations.add Ellington::Station.new("168th Street")
#    route[line.name] = line
#
#
#    context = Object.new # the wrapped context. in our case it would be a submission object
#
#    passenger = Ellington::Passenger.new(context)
#    passenger.ticket = Ellington::Ticket.new(context)
#
#    # manually acting as conductor and putting the passenger on the route
#
#    conductor = Ellington::Conductor.new(route)
#    conductor.guide(passenger)
#
#
#    if passenger.can_travel? && 
#      passenger.ticket.ok?(route, line, station) &&
#      passenger.effective?(route, line, station)
#
#      passenger.depart(route, line, station)
#    end
  end

end
