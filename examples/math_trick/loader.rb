require_relative "../../lib/ellington"

%w(stations lines routes).each do |dir|
  $:.unshift File.join(File.dirname(__FILE__), dir)
end

%w{
  add_station
  first_reverse_station
  second_reverse_station
  subtract_station
  trick_with_1089
  math_trick
}.each { |file| require file }
