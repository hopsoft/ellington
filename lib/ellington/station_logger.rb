require "singleton"

module Ellington
  class StationLogger
    include Singleton

    def update(station, passenger, transitions)
      data = {
        :route       => station.line.route,
        :line        => station.line,
        :station     => station,
        :passenger   => passenger,
        :transitions => transitions
      }

      # TODO: log this data
    end

  end
end
