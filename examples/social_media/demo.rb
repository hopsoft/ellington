require "logger"
require_relative "loader"

Ellington.logger = Logger.new(STDOUT)
route = Blast.new
route.add_observer BlastObserver.new, :route_completed
conductor = Ellington::Conductor.new(route)

while true
  sleep 1 # mock latency

  (0..10).map do
    # Find users that should ride the route
    # In a typical app, we might select users from the database
    # or pull them off of a message queue
    user = User.new

    # put the passenger on the train
    conductor.conduct user
  end
end

