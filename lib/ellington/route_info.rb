require "delegate"

module Ellington
  class RouteInfo < SimpleDelegator
    attr_reader :route, :line_info

    def initialize(route, line_info)
      @route = route
      @line_info = line_info
      super line_info
    end

    def log_message(options={})
      message = []
      message << "[ROUTE COMPLETED]"
      message << "[#{route.state(passenger)}]"
      message << "[#{route.name}]"
      line.route.log_passenger_attrs.each do |attr|
        message << "[#{attr}:#{passenger.send(attr)}]"
      end
      message.join " "
    end
  end
end

