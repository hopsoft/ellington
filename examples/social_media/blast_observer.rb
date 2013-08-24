# An observer that is notified when a passenger completes a route.
# This implementation graphs the entire route for each passenger showing what
# path the passenger actually took through the various lines and stations.

require "fileutils"

class BlastObserver
  include FileUtils

  attr_reader :route, :visualizer, :base_path

  def initialize
    @visualizer = Ellington::Visualizer.new(Blast)
    @base_path = File.expand_path("../visualizations/passengers", __FILE__)
    rm_rf base_path
    mkdir_p base_path
  end

  def route_completed(route_info)
    Thread.new do
      path = File.join(base_path, route_info.passenger.id)
      mkdir_p path

      File.open(File.join(path, "route_basic.svg"), "w") do |f|
        f.write visualizer.graph_route_basic(route_info.passenger)
      end

      File.open(File.join(path, "route.svg"), "w") do |f|
        f.write visualizer.graph_route(route_info.passenger)
      end

      File.open(File.join(path, "lines_basic.svg"), "w") do |f|
        f.write visualizer.graph_lines_basic(route_info.passenger)
      end

      File.open(File.join(path, "lines.svg"), "w") do |f|
        f.write visualizer.graph_lines(route_info.passenger)
      end
    end
  end
end
