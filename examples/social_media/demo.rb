require "yell"
require_relative "loader"

Ellington.logger = Yell.new do |logger|
  logger.adapter STDOUT, :level => [:info], :format => "%m"
end
#Ellington.logger = Logger.new($stdout)

route = Blast.new
RouteObserver.new(route)
conductor = Conductor.new(route)
conductor.start
conductor.wait

