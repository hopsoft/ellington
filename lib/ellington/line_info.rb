require "delegate"

module Ellington
  class LineInfo < SimpleDelegator
    attr_reader :line, :station_info

    def initialize(line, station_info)
      @line = line
      @station_info = station_info
      super station_info
    end

    def name
      @name ||= "#{station.class.name} <member of> #{line.class.name} <member of> #{line.route.name}"
    end

    def log_message(options={})
      message = []
      if options[:line_completed]
        message << "[LINE COMPLETED]"
        message << "[#{line.state(passenger)}]"
      end
      if options[:station_completed]
        message << "[STATION COMPLETED]"
        message << "[#{station.state(passenger)}]"
      end
      message << "[#{name}]"
      message << "[passenger_state:#{passenger.current_state}]"
      message << "[old_passenger_state:#{transition.old_state}]"
      line.route.log_passenger_attrs.each do |attr|
        message << "[#{attr}:#{passenger.send(attr)}]"
      end
      message.join " "
    end
  end
end
