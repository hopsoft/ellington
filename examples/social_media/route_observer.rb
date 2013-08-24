# An observer that is notified when a passenger completes a route.
# This implementation graphs the entire route for each passenger showing what
# path the passenger actually took through the various lines and stations.

require "fileutils"

class RouteObserver
  include FileUtils
  attr_reader :route, :visualizer

  def initialize(route)
    @route = route
    @visualizer = Ellington::Visualizer.new(route.class)
    @path = File.expand_path("../visualizations/passengers", __FILE__)
    rm_rf @path
    mkdir_p @path
    route.add_observer self, :route_completed
  end

  def route_completed(route_info)
    Thread.new do
      path = File.join(@path, route_info.passenger.id)
      mkdir_p path

      File.open(File.join(path, "route_basic.svg"), "w") do |file|
        file.write visualizer.graph_route_basic(route_info.passenger)
      end

      File.open(File.join(path, "route.svg"), "w") do |file|
        file.write visualizer.graph_route(route_info.passenger)
      end

      File.open(File.join(path, "lines_basic.svg"), "w") do |file|
        file.write visualizer.graph_lines_basic(route_info.passenger)
      end

      File.open(File.join(path, "lines.svg"), "w") do |file|
        file.write visualizer.graph_lines(route_info.passenger)
      end
    end
  end
end
