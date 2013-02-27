require "delegate"

# options: http://www.graphviz.org/doc/info/attrs.html
# colors: http://www.graphviz.org/doc/info/colors.html
module Ellington
  class Visualizer

    class Node < SimpleDelegator
      attr_reader :base, :viz, :children

      def initialize(base, viz)
        @base = base
        @viz = viz
        @children = []
        super children
      end

      def name
        viz.id
      end

      def find(context)
        if context.is_a?(String)
          to_a.select{ |node| node.name == context }.first
        else
          to_a.select{ |node| node.base == context }.first
        end
      end
    end

    attr_reader :route

    def initialize(route)
      @route = route
    end

    def test
      g = GraphViz::new( "structs" )

      g.node["shape"] = "record"

      struct1 = g.add_nodes( "struct1", "shape" => "record", "label" => "<f0> left|<f1> mid\ dle|<f2> right" )
      struct2 = g.add_nodes( "struct2", "shape" => "record", "label" => "<f0> one|<f1> two" )
      struct3 = g.add_nodes( "struct3", "shape" => "record", "label" => 'hello\nworld |{ b |{c|<here> d|e}| f}| g | h' )

      g.add_edges( struct1, struct2 )
      g.add_edges( struct1, struct3 )

      g.output( :pdf => "#{route.name}.pdf" )
    end

    def graph_lines_basic
      g = Node.new(nil, GraphViz.new("G"))
      g.viz["label"] = "#{route.name} Lines"
      g.viz["fontname"] = "Helvetica"
      g.viz.node["fontname"] = "Helvetica"
      g.viz.node["shape"] = "box"
      g.viz.node["style"] = "rounded"

      route.lines.each_with_index do |line, index|
        line_cluster = Node.new(line, g.viz.add_graph("cluster#{index}"))
        line_cluster.viz["label"] = line.class.name
        g << line_cluster

        line.stations.each_with_index.each do |station, station_index|
          station_node = Node.new(station, line_cluster.viz.add_nodes(station.class.name))
          line_cluster << station_node
        end

        line_cluster.each_with_index.each do |node, node_index|
          next_node = line_cluster[node_index + 1]
          line_cluster.viz.add_edges node.viz, next_node.viz if next_node
        end
      end

      g.viz.output(:pdf => "#{route.name}.pdf")
    end

    def graph_lines
      binding.pry
      g = Node.new(nil, GraphViz.new("G"))
      g.viz["label"] = "#{route.name} Lines"
      g.viz["fontname"] = "Helvetica"
      g.viz.node["fontname"] = "Helvetica"
      g.viz.node["shape"] = "box"
      g.viz.node["style"] = "rounded"

      route.lines.each_with_index do |line, index|
        line_cluster = Node.new(line, g.viz.add_graph("cluster#{index}"))
        line_cluster.viz["label"] = line.class.name
        g << line_cluster

        line.states.keys.each do |state|
          state_node = Node.new(state, line_cluster.viz.add_nodes(state))
          line_cluster << state_node
        end

        line.states.each do |state, transitions|
          a = line_cluster.find(state)
          (transitions || []).each do |transition|
            b = line_cluster.find(transition)
            line_cluster.viz.add_edges a.viz, b.viz rescue binding.pry
          end
        end
      end

      g.viz.output(:pdf => "#{route.name}.pdf")
    end


    def short_name(state)
      return "pass" if state =~ /\APASS/i
      return "fail" if state =~ /\AFAIL/i
      return "error" if state =~ /\AERROR/i
    end










































































#    def graph_states
#      graph = GraphViz.new("G")
#      #graph["label"] = "#{route.name} States"
#      #graph.node["shape"] = "box"
#
#      cluster_styled = false
#      cluster2_styled = false
#      clusters = {}
#      nodes = {}
#
#      route.states.each do |state, states|
#        line = line_for_state(state)
#        cluster = nil
#        if line
#          cluster = clusters[line] || graph.add_graph(line.class.name)
#          clusters[line] = cluster
#          if !cluster_styled
#            cluster["label"] = line.class.name
#            cluster["style"] = "filled"
#            cluster["color"] = "lightgrey"
#            cluster_styled = true
#          end
#        end
#
#        node = nodes[state] || (cluster || graph).add_nodes(state)
#        nodes[state] = node
#
#        (states || []).each do |state2|
#          line2 = line_for_state(state2)
#          cluster2 = nil
#          if line2
#            cluster2 = clusters[line2] || graph.add_graph(line2.class.name, "label" => line2.class.name)
#            clusters[line2] = cluster2
#          end
#
#          node2 = nodes[state2] || (cluster2 || graph).add_nodes(state2)
#          nodes[state2] = node2
#
#          if cluster && ([state, state2] & line.states.keys).length == 2
#            cluster.add_edges node, node2
#          else
#            graph.add_edges node, node2
#          end
#        end
#      end
#
#      route.lines.each do |line|
#        line.goal.each do |state|
#          nodes[state].color = "greenyellow"
#          nodes[state].style = "filled"
#        end
#      end
#
#      route.goal.each do |state|
#        nodes[state].color = "green2"
#        nodes[state].style = "filled"
#      end
#
#      graph.output(:pdf => "#{route.name}.pdf")
#    end
#
#    def graph_lines
#      # Create a new graph
#      g = GraphViz.new(:G, :type => :digraph)
#
#      nodes = {}
#      node_paths = {}
#
#      route.lines.each do |line|
#        nodes[line] ||= {}
#        nodes[line]["PASS"] = g.add_nodes("#{line.class.name} [PASS]")
#        nodes[line]["PASS"].color = "green"
#        nodes[line]["FAIL"] = g.add_nodes("#{line.class.name} [FAIL]")
#        nodes[line]["FAIL"].color = "red"
#        nodes[line]["ERROR"] = g.add_nodes("#{line.class.name} [ERROR]")
#        node_paths[line.passed] = []
#        node_paths[line.failed] = []
#        node_paths[line.errored] = []
#      end
#
#      route.lines.each do |line|
#        g.add_edges nodes[line]["ERROR"], nodes[line]["PASS"]
#        g.add_edges nodes[line]["ERROR"], nodes[line]["FAIL"]
#        node_paths[line.passed] << line.errored
#        node_paths[line.failed] << line.errored
#      end
#
#      start = g.add_nodes("START")
#      start.color = "green"
#      g.add_edges start, nodes.first.last["PASS"]
#      g.add_edges start, nodes.first.last["FAIL"]
#      g.add_edges start, nodes.first.last["ERROR"]
#
#      connections = {}
#      route.connections.each do |connection|
#        if connection.type == :if_any
#          route.lines.each do |line|
#            if (connection.states & line.passed).length == line.passed.length
#              g.add_edges nodes[line]["PASS"], nodes[connection.line]["PASS"]
#              g.add_edges nodes[line]["PASS"], nodes[connection.line]["FAIL"]
#              g.add_edges nodes[line]["PASS"], nodes[connection.line]["ERROR"]
#              node_paths[connection.line.passed] << line.passed
#              node_paths[connection.line.failed] << line.passed
#              node_paths[connection.line.errored] << line.passed
#            elsif (connection.states & line.failed).length == line.passed.length
#              g.add_edges nodes[line]["FAIL"], nodes[connection.line]["PASS"]
#              g.add_edges nodes[line]["FAIL"], nodes[connection.line]["FAIL"]
#              g.add_edges nodes[line]["FAIL"], nodes[connection.line]["ERROR"]
#              node_paths[connection.line.passed] << line.failed
#              node_paths[connection.line.failed] << line.failed
#              node_paths[connection.line.errored] << line.failed
#            elsif (connection.states & line.errored).length == line.passed.length
#              g.add_edges nodes[line]["ERROR"], nodes[connection.line]["PASS"]
#              g.add_edges nodes[line]["ERROR"], nodes[connection.line]["FAIL"]
#              g.add_edges nodes[line]["ERROR"], nodes[connection.line]["ERROR"]
#              node_paths[connection.line.passed] << line.errored
#              node_paths[connection.line.failed] << line.errored
#              node_paths[connection.line.errored] << line.errored
#            end
#          end
#        end
#      end
#
#      route.connections.each do |connection|
#        if connection.type == :if_all
#          node_paths.each do |target, path|
#            line = route.lines.to_a.select{ |line| (line.states.keys & target).length == target.length }.first
#            if line
#              combined = (target + path).flatten
#              if (connection.states & line.passed).length == line.passed.length && 
#                (combined & connection.states).length == connection.states.length
#                g.add_edges nodes[line]["PASS"], nodes[connection.line]["PASS"]
#                g.add_edges nodes[line]["PASS"], nodes[connection.line]["FAIL"]
#                g.add_edges nodes[line]["PASS"], nodes[connection.line]["ERROR"]
#              end
#              if (connection.states & line.failed).length == line.failed.length &&
#                (combined & connection.states).length == connection.states.length
#                g.add_edges nodes[line]["FAIL"], nodes[connection.line]["PASS"]
#                g.add_edges nodes[line]["FAIL"], nodes[connection.line]["FAIL"]
#                g.add_edges nodes[line]["FAIL"], nodes[connection.line]["ERROR"]
#              end
#              if (connection.states & line.errored).length == line.errored.length &&
#                (combined & connection.states).length == connection.states.length
#                g.add_edges nodes[line]["ERROR"], nodes[connection.line]["PASS"]
#                g.add_edges nodes[line]["ERROR"], nodes[connection.line]["FAIL"]
#                g.add_edges nodes[line]["ERROR"], nodes[connection.line]["ERROR"]
#              end
#            end
#          end
#        end
#      end
#
#      route.lines.each do |line|
#        if (line.passed & route.goal).length == line.passed.length
#          nodes[line]["PASS"].penwidth = 3
#        end
#        if (line.failed & route.goal).length == line.failed.length
#          nodes[line]["FAIL"].penwidth = 3
#        end
#        if (line.errored & route.goal).length == line.errored.length
#          nodes[line]["ERROR"].penwidth = 3
#        end
#      end
#
#      g.output(:pdf => "#{route.name}.pdf")
#    end
#
#    def line_for_state(state)
#      route.lines.to_a.select { |line| line.states.keys.include? state }.first
#    end

  end
end
