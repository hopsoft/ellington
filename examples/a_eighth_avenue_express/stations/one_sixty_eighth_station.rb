# station where passenger get a latte from starbucks
class OneSixtyEigthStation < Ellington::Station
  transitions_passenger_to(
    :obtained_latte, 
    :spilled_latte, 
    :error_obtaining_latte
  )

  def engage(passenger, options)
    # TODO: add more sophisticated logic here to illustrate a more real world use case
    if rand(10) > 5
      passenger.transition_to :obtained_latte
    else
      passenger.transition_to :spilled_latte
    end
  rescue
    passenger.transition_to :error_obtaining_latte
  end
end
