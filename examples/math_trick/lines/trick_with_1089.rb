class TrickWith1089 < Ellington::Line
  stations << FirstReverseStation.new
  stations << SubtractStation.new
  stations << SecondReverseStation.new
  stations << AddStation.new

  goal stations.last.passed
end
