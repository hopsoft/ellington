require "graphviz"

# options: http://www.graphviz.org/doc/info/attrs.html
# colors: http://www.graphviz.org/doc/info/colors.html
module Ellington
  class Visualizer
    attr_reader :route

    def initialize(route)
      @route = route
    end

    def graph_test
      g = GraphViz.new("G")
      c0 = g.add_graph( "cluster0" )
      c0["label"] = "process #1"
      c0["style"] = "filled"
      c0["color"] = "lightgrey"
      a0 = c0.add_nodes( "a0", "style" => "filled", "color" => "white" )
      a1 = c0.add_nodes( "a1", "style" => "filled", "color" => "white" )
      a2 = c0.add_nodes( "a2", "style" => "filled", "color" => "white" )
      a3 = c0.add_nodes( "a3", "style" => "filled", "color" => "white" )
      c0.add_edges( a0, a1 )
      c0.add_edges( a1, a2 )
      c0.add_edges( a2, a3 )

      c1 = g.add_graph( "cluster1", "label" => "process #2" )
      b0 = c1.add_nodes( "b0", "style" => "filled", "color" => "blue" )
      b1 = c1.add_nodes( "b1", "style" => "filled", "color" => "blue" )
      b2 = c1.add_nodes( "b2", "style" => "filled", "color" => "blue" )
      b3 = c1.add_nodes( "b3", "style" => "filled", "color" => "blue" )
      c1.add_edges( b0, b1 )
      c1.add_edges( b1, b2 )
      c1.add_edges( b2, b3 )

      start = g.add_nodes( "start", "shape" => "Mdiamond" )
      endn  = g.add_nodes( "end",   "shape" => "Msquare" )

      g.add_edges( start, a0 )
      g.add_edges( start, b0 )
      g.add_edges( a1, b3 )
      g.add_edges( b2, a3 )
      g.add_edges( a3, a0 )
      g.add_edges( a3, endn )
      g.add_edges( b3, endn )

      g.output( :pdf => "graph_test.pdf" )
    end

    def graph_states
      graph = GraphViz.new("G")
      graph["label"] = "#{route.name} States"
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

    def graph_lines
      # Create a new graph
      g = GraphViz.new(:G, :type => :digraph)

      nodes = {}
      node_paths = {}

      route.lines.each do |line|
        nodes[line] ||= {}
        nodes[line]["PASS"] = g.add_nodes("#{line.class.name} [PASS]")
        nodes[line]["PASS"].color = "green"
        nodes[line]["FAIL"] = g.add_nodes("#{line.class.name} [FAIL]")
        nodes[line]["FAIL"].color = "red"
        nodes[line]["ERROR"] = g.add_nodes("#{line.class.name} [ERROR]")
        node_paths[line.passed] = []
        node_paths[line.failed] = []
        node_paths[line.errored] = []
      end

      route.lines.each do |line|
        g.add_edges nodes[line]["ERROR"], nodes[line]["PASS"]
        g.add_edges nodes[line]["ERROR"], nodes[line]["FAIL"]
        node_paths[line.passed] << line.errored
        node_paths[line.failed] << line.errored
      end

      start = g.add_nodes("START")
      start.color = "green"
      g.add_edges start, nodes.first.last["PASS"]
      g.add_edges start, nodes.first.last["FAIL"]
      g.add_edges start, nodes.first.last["ERROR"]

      connections = {}
      route.connections.each do |connection|
        if connection.type == :if_any
          route.lines.each do |line|
            if (connection.states & line.passed).length == line.passed.length
              g.add_edges nodes[line]["PASS"], nodes[connection.line]["PASS"]
              g.add_edges nodes[line]["PASS"], nodes[connection.line]["FAIL"]
              g.add_edges nodes[line]["PASS"], nodes[connection.line]["ERROR"]
              node_paths[connection.line.passed] << line.passed
              node_paths[connection.line.failed] << line.passed
              node_paths[connection.line.errored] << line.passed
            elsif (connection.states & line.failed).length == line.passed.length
              g.add_edges nodes[line]["FAIL"], nodes[connection.line]["PASS"]
              g.add_edges nodes[line]["FAIL"], nodes[connection.line]["FAIL"]
              g.add_edges nodes[line]["FAIL"], nodes[connection.line]["ERROR"]
              node_paths[connection.line.passed] << line.failed
              node_paths[connection.line.failed] << line.failed
              node_paths[connection.line.errored] << line.failed
            elsif (connection.states & line.errored).length == line.passed.length
              g.add_edges nodes[line]["ERROR"], nodes[connection.line]["PASS"]
              g.add_edges nodes[line]["ERROR"], nodes[connection.line]["FAIL"]
              g.add_edges nodes[line]["ERROR"], nodes[connection.line]["ERROR"]
              node_paths[connection.line.passed] << line.errored
              node_paths[connection.line.failed] << line.errored
              node_paths[connection.line.errored] << line.errored
            end
          end
        end
      end

      route.connections.each do |connection|
        if connection.type == :if_all
          node_paths.each do |target, path|
            line = route.lines.to_a.select{ |line| (line.states.keys & target).length == target.length }.first
            if line
              combined = (target + path).flatten
              if (connection.states & line.passed).length == line.passed.length && 
                (combined & connection.states).length == connection.states.length
                g.add_edges nodes[line]["PASS"], nodes[connection.line]["PASS"]
                g.add_edges nodes[line]["PASS"], nodes[connection.line]["FAIL"]
                g.add_edges nodes[line]["PASS"], nodes[connection.line]["ERROR"]
              end
              if (connection.states & line.failed).length == line.failed.length &&
                (combined & connection.states).length == connection.states.length
                g.add_edges nodes[line]["FAIL"], nodes[connection.line]["PASS"]
                g.add_edges nodes[line]["FAIL"], nodes[connection.line]["FAIL"]
                g.add_edges nodes[line]["FAIL"], nodes[connection.line]["ERROR"]
              end
              if (connection.states & line.errored).length == line.errored.length &&
                (combined & connection.states).length == connection.states.length
                g.add_edges nodes[line]["ERROR"], nodes[connection.line]["PASS"]
                g.add_edges nodes[line]["ERROR"], nodes[connection.line]["FAIL"]
                g.add_edges nodes[line]["ERROR"], nodes[connection.line]["ERROR"]
              end
            end
          end
        end
      end

      route.lines.each do |line|
        if (line.passed & route.goal).length == line.passed.length
          nodes[line]["PASS"].penwidth = 3
        end
        if (line.failed & route.goal).length == line.failed.length
          nodes[line]["FAIL"].penwidth = 3
        end
        if (line.errored & route.goal).length == line.errored.length
          nodes[line]["ERROR"].penwidth = 3
        end
      end

      g.output(:pdf => "#{route.name}.pdf")
    end

    def line_for_state(state)
      route.lines.to_a.select { |line| line.states.keys.include? state }.first
    end

  end
end
