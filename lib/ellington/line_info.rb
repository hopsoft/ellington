require "delegate"

module Ellington
  class LineInfo < SimpleDelegator
    attr_reader :line, :station_info

    def initialize(line, station_info)
      @line = line
      @station_info = station_info
      super station_info
    end

    def station_full_name
      @station_full_name ||= "#{station.class.name}::#{line.class.name}::#{line.route.name}"
    end

    def log_message(options={})
      message = []
      if options[:line_completed]
        message << "[LINE COMPLETED]"
        message << "[#{line.state(passenger)}]"
        message << "[#{line.name}]"
      end
      if options[:station_completed]
        message << "[STATION COMPLETED]"
        message << "[#{station.state(passenger)}]"
        message << "[#{station_full_name}]"
      end
      line.route.log_passenger_attrs.each do |attr|
        message << "[#{attr}:#{passenger.send(attr)}]"
      end
      message.join " "
    end
  end
end
