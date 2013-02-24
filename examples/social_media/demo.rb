require "yell"
require "securerandom"
require_relative "loader"

Ellington.logger = Yell.new do |logger|
  logger.adapter STDOUT, :level => [:info], :format => "%m"
end
#Ellington.logger = Logger.new($stdout)

# A basic user object for demo purposes.
class User

  def id
    @id ||= SecureRandom.uuid
  end

  def current_message
    @current_message ||= "My favorite number is #{rand(9999)}!"
  end

end

# A conductor for the Blast route.
class BlastConductor < Ellington::Conductor

  def gather_passengers
    #sleep 1 # wait a bit between batches

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

conductor = BlastConductor.new(Blast.new)
conductor.start
conductor.wait

