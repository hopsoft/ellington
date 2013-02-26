require "graphviz"

# options: http://www.graphviz.org/doc/info/attrs.html
# colors: http://www.graphviz.org/doc/info/colors.html
module Ellington
  class Visualizer
    attr_reader :route

    def initialize(route)
      @route = route
    end

    def graph_states
      graph = GraphViz.new("G")
      graph.node["shape"] = "box"

      clusters = {}
      nodes = {}

      route.states.each do |state, states|
        line = line_for_state(state)
        cluster = nil
        if line
          cluster = clusters[line] || graph.add_graph(line.class.name, "label" => line.class.name)
          clusters[line] = cluster
        end

        node = nodes[state] || (cluster || graph).add_nodes(state)
        nodes[state] = node

        (states || []).each do |state2|
          line2 = line_for_state(state2)
          cluster2 = nil
          if line2
            cluster2 = clusters[line2] || graph.add_graph(line2.class.name, "label" => line2.class.name)
            clusters[line2] = cluster2
          end

          node2 = nodes[state2] || (cluster2 || graph).add_nodes(state2)
          nodes[state2] = node2

          if cluster && ([state, state2] & line.states.keys).length == 2
            cluster.add_edges node, node2
          else
            graph.add_edges node, node2
          end
        end
      end

      route.lines.each do |line|
        line.goal.each do |state|
          nodes[state].color = "greenyellow"
          nodes[state].style = "filled"
        end
      end

      route.goal.each do |state|
        nodes[state].color = "green2"
        nodes[state].style = "filled"
      end

      graph.output(:pdf => "#{route.name}.pdf")
    end

    def line_for_state(state)
      route.lines.to_a.select { |line| line.states.keys.include? state }.first
    end

  end

end
