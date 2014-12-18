class MockStationHelper
  attr_reader :station

  def initialize(station)
    @station = station
  end

  def mock_engage(user)
    # Add some fakery so it feels like its working.
    begin
      raise if rand(100) == 0
      ok = rand(100) > 5

      if ok
        station.pass_passenger user
      else
        station.fail_passenger user
      end
    rescue
      station.error_passenger user
    end
  end

end
