require "yell"
require_relative "loader"

Ellington.logger = Yell.new do |logger|
  logger.adapter STDOUT, :level => [:info], :format => "%m"
end
#Ellington.logger = Logger.new($stdout)

route = Blast.new
observer = RouteObserver.new(route)
conductor = BlastConductor.new(route)
conductor.start
conductor.wait

