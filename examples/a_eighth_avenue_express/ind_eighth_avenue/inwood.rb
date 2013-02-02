# station where passengers obtain sunglasses from miami fashion
class InwoodStation < Ellington::Station
  transitions_passenger_to(
    :obtained_sunglasses,
    :lost_sunglasses,
    :error_obtaining_sunglasses
  )

  def engage(passenger, options)
    # TODO: add more sophisticated logic here to illustrate a more real world use case
    if rand(10) > 5
      passenger.transition_to :obtained_sunglasses
    else
      passenger.transition_to :lost_sunglasses
    end
  rescue
    passenger.transition_to :error_obtaining_sunglasses
  end
end
