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
      @station_full_name ||= "#{line.route.name} #{line.class.name} #{station.class.name}"
    end

    def station_completed_message
      message = []
      message << "[STATION COMPLETED]"
      message << "[#{station.state(passenger)}]"
      message << "[#{station_full_name}]"
      message.concat passenger_message
      message.join " "
    end

    def line_completed_message
      message = []
      message << "[LINE COMPLETED]"
      message << "[#{line.state(passenger)}]"
      message << "[#{line.name}]"
      message.concat passenger_message
      message.join " "
    end

    def passenger_message
      line.route.passenger_attrs_to_log.map do |attr|
        "[#{attr}:#{passenger.send(attr)}]"
      end
    end

  end
end
