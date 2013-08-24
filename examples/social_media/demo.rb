require "yell"
require_relative "loader"

Ellington.logger = Yell.new do |logger|
  logger.adapter STDOUT, :level => [:info], :format => "%m"
end
#Ellington.logger = Logger.new($stdout)

route = Blast.new
route.add_observer BlastObserver.new, :route_completed
conductor = Ellington::Conductor.new(route)

while true
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

    conductor.conduct passenger
  end
end

