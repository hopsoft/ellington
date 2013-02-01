# This test is loosely modeled after the actual A train in New York.
# http://en.wikipedia.org/wiki/A_(New_York_City_Subway_service)


# obtain sunglasses from miami fashion
class InwoodStation < Ellington::Station
  transitions_passenger_to(
    :obtained_sunglasses,
    :lost_sunglasses,
    :error_obtaining_sunglasses
  )

  def engage(passenger, options)
    # TODO: add more detailed logic here to illustrate a more real world use case
    if rand(10) > 5
      passenger.transition_to :obtained_sunglasses
    else
      passenger.transition_to :lost_sunglasses
    end
  rescue
    passenger.transition_to :error_obtaining_sunglasses
  end
end

# get a latte from starbucks
class OneSixtyEigthStation < Ellington::Station
  transitions_passenger_to(
    :obtained_latte, 
    :spilled_latte, 
    :error_obtaining_latte
  )

  def engage(passenger, options)
    # TODO: add more detailed logic here to illustrate a more real world use case
    if rand(10) > 5
      passenger.transition_to :obtained_latte
    else
      passenger.transition_to :spilled_latte
    end
  rescue
    passenger.transition_to :error_obtaining_latte
  end
end

line = Ellington::Line.new("IND Eighth Avenue Line")
line << ATrain::InwoodStation.new("Inwood - 207th Street")
line << OneSixtyEigthStation.new("")

route = Ellington::Route.new("A Eighth Avenue Express")
route.add line
