require_relative "loader"

path = File.expand_path("../visualizations", __FILE__)

File.open(File.join(path, "route_basic.svg"), "w") do |file|
  file.write Ellington::Visualizer.new(Blast).graph_route_basic
end

File.open(File.join(path, "route.svg"), "w") do |file|
  file.write Ellington::Visualizer.new(Blast).graph_route
end

File.open(File.join(path, "lines_basic.svg"), "w") do |file|
  file.write Ellington::Visualizer.new(Blast).graph_lines_basic
end

File.open(File.join(path, "lines.svg"), "w") do |file|
  file.write Ellington::Visualizer.new(Blast).graph_lines
end

