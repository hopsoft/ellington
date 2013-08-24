# A simple script that illustrates how to generate graphs
# to visualize an Ellington route.

require "fileutils"
require_relative "loader"

path = File.expand_path("../visualizations", __FILE__)
FileUtils.mkdir_p path
FileUtils.rm_rf File.join(path, "*.svg")

viz = Ellington::Visualizer.new(Blast)

file_path = File.join(path, "route_basic.svg")
File.open(file_path, "w") { |f| f.write viz.graph_route_basic }

file_path = File.join(path, "route.svg")
File.open(file_path, "w") { |f| f.write viz.graph_route }

file_path = File.join(path, "lines_basic.svg")
File.open(file_path, "w") { |f| f.write viz.graph_lines_basic }

file_path = File.join(path, "lines.svg")
File.open(file_path, "w") { |f| f.write viz.graph_lines }

