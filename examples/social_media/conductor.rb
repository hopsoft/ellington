require_relative "user"

# A conductor for the Blast route.
class BlastConductor < Ellington::Conductor

  def gather_passengers
    sleep 1 # mock latency

    (0..10).map do
      # Find users that should ride the route.
      # In a typical app, we might select users from the database
      # or pull them off of a message queue.
      user = User.new

      # Wrap the passenger.
      passenger = Ellington::Passenger.new(user, route)

      # Prepare the passenger for riding.
      passenger.current_state = route.initial_state
      passenger.lock

      passenger
    end
  end

end
