require "delegate"

module Ellington
  class RouteInfo < SimpleDelegator
    attr_reader :route, :line_info

    def initialize(route, line_info)
      @route = route
      @line_info = line_info
      super line_info
    end

    def route_completed_message
      message = []
      message << "[ROUTE COMPLETED]"
      message << "[#{route.state(passenger)}]"
      message << "[#{route.name}]"
      message.concat passenger_message
      message.join " "
    end

    def passenger_message
      route.passenger_attrs_to_log.reduce([]) do |memo, attr|
        value = passenger.send(attr) rescue nil
        memo << "[#{attr}:#{value}]" unless value.nil?
        memo
      end
    end
  end
end

