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

    attr_reader :route, :dir, :format

    def initialize(route, dir, format=:svg)
      @route = route
      @dir = dir
      @format = format
    end

    FONTNAME = "Helvetica"
    RANKSEP = 0.4
    NODE_COLOR = "white"
    NODE_COLOR_VIRTUAL = "gray50"
    NODE_COLOR_LINE_GOAL = "green2"
    NODE_COLOR_ROUTE_GOAL = "gold"
    NODE_COLOR_PASSENGER_HIT = "green3"
    NODE_FILLCOLOR = "white"
    NODE_FILLCOLOR_LINE_GOAL = "green2"
    NODE_FILLCOLOR_ROUTE_GOAL = "gold"
    NODE_FONTCOLOR_VIRTUAL = "gray40"
    NODE_SHAPE = "box"
    NODE_STYLE = "filled,rounded"
    NODE_STYLE_VIRTUAL = "rounded"
    NODE_PENWIDTH_PASSENGER_HIT = 2
    EDGE_PENWIDTH_PASSENGER_HIT = 2
    EDGE_COLOR_PASSENGER_HIT = "green3"
    EDGE_STYLE_PASSENGER_MISS = "dotted"
    CLUSTER_STYLE = "filled"
    CLUSTER_COLOR = "gray70"
    CLUSTER_FILLCOLOR = "gray70"
    CLUSTER_PENCOLOR = "gray50"

    def graph_all(passenger=nil)
      graph_route_basic passenger
      graph_route passenger
      graph_lines_basic passenger
      graph_lines passenger
    end

    def graph_lines_basic(passenger=nil)
      g = Node.new(nil, GraphViz.new("GraphLinesBasic"))
      set_graph_defaults g.viz
      g.viz["label"] = "#{route.name} Lines - basic"

      route.lines.each_with_index do |line, index|
        line_cluster = Node.new(line, g.viz.add_graph("cluster#{index}"))
        set_cluster_defaults line_cluster.viz
        line_cluster.viz["label"] = line.class.name
        g << line_cluster

        line.stations.each do |station|
          station_node = Node.new(station, line_cluster.viz.add_nodes(station.class.name))
          line_cluster << station_node

          if !(line.goal & station.states.keys).empty?
            station_node.viz["color"] = NODE_COLOR_LINE_GOAL
            station_node.viz["fillcolor"] = NODE_COLOR_LINE_GOAL
          end

          if !(route.goal & station.states.keys).empty?
            station_node.viz["color"] = NODE_COLOR_ROUTE_GOAL
            station_node.viz["fillcolor"] = NODE_COLOR_ROUTE_GOAL
          end

          if passenger && !(passenger.state_history & station.states.keys).empty?
            station_node.viz["color"] = NODE_COLOR_PASSENGER_HIT
            station_node.viz["penwidth"] = NODE_PENWIDTH_PASSENGER_HIT
          end
        end

        line_cluster.each_with_index.each do |node, node_index|
          next_node = line_cluster[node_index + 1]
          if next_node
            station = node.base
            next_station = next_node.base
            edge = line_cluster.viz.add_edges(node.viz, next_node.viz)
            if passenger 
              if node.viz["color"] == NODE_COLOR_PASSENGER_HIT &&
                next_node.viz["color"] == NODE_COLOR_PASSENGER_HIT
                edge["color"] = EDGE_COLOR_PASSENGER_HIT
                edge["penwidth"] = EDGE_PENWIDTH_PASSENGER_HIT
              else
                edge["style"] = EDGE_STYLE_PASSENGER_MISS
              end
            end
          end
        end
      end

      file_name = "#{route.name.downcase.gsub("::", "_")}-lines-basic.#{format}"
      g.viz.output(format => File.join(dir, file_name))
    end

    def graph_lines(passenger=nil)
      g = Node.new(nil, GraphViz.new("GraphLines"))
      set_graph_defaults g.viz
      g.viz["label"] = "#{route.name} Lines"

      route.lines.each_with_index do |line, index|
        line_cluster = Node.new(line, g.viz.add_graph("cluster#{index}"))
        set_cluster_defaults line_cluster.viz
        line_cluster.viz["label"] = line.class.name
        g << line_cluster

        line.states.keys.each do |state|
          state_node = Node.new(state, line_cluster.viz.add_nodes(state))
          if line.goal.include?(state)
            state_node.viz["color"] = NODE_COLOR_LINE_GOAL
            state_node.viz["fillcolor"] = NODE_FILLCOLOR_LINE_GOAL
          end
          if route.goal.include?(state)
            state_node.viz["color"] = NODE_COLOR_ROUTE_GOAL
            state_node.viz["fillcolor"] = NODE_FILLCOLOR_ROUTE_GOAL
          end
          if passenger && passenger.state_history_includes?(state)
            state_node.viz["color"] = NODE_COLOR_PASSENGER_HIT
            state_node.viz["penwidth"] = NODE_PENWIDTH_PASSENGER_HIT
          end
          line_cluster << state_node
        end

        line.states.each do |state, transitions|
          a = line_cluster.find(state)
          (transitions || []).each do |transition|
            b = line_cluster.find(transition)
            edge = line_cluster.viz.add_edges(a.viz, b.viz)
            if passenger 
              if passenger.state_history_includes?(state, transition)
                edge["color"] = EDGE_COLOR_PASSENGER_HIT
                edge["penwidth"] = EDGE_PENWIDTH_PASSENGER_HIT
              else
                edge["style"] = EDGE_STYLE_PASSENGER_MISS
              end
            end
          end
        end
      end

      file_name = "#{route.name.downcase.gsub("::", "_")}-lines.#{format}"
      g.viz.output(format => File.join(dir, file_name))
    end

    def graph_route_basic(passenger=nil)
      g = Node.new(nil, GraphViz.new("GraphRouteBasic"))
      set_graph_defaults g.viz
      g.viz["ranksep"] = 1
      g.viz["label"] = "#{route.name} Route - basic"

      route.lines.each_with_index do |line, index|
        line_cluster = Node.new(line, g.viz.add_graph("cluster#{index}"))
        set_cluster_defaults line_cluster.viz
        line_cluster.viz["label"] = line.class.name
        g << line_cluster

        passenger_hit = false
        %w{PASS FAIL ERROR}.each do |state|
          state_node = Node.new(state, line_cluster.viz.add_nodes("#{line.class.name}#{state}", "label" => state))
          line_cluster << state_node
          states = line.stations.map{ |s| "#{state} #{s.name}" }

          if !(line.goal & states).empty?
            state_node.viz["color"] = NODE_COLOR_LINE_GOAL
            state_node.viz["fillcolor"] = NODE_COLOR_LINE_GOAL
          end

          if !(route.goal & states).empty?
            state_node.viz["color"] = NODE_COLOR_ROUTE_GOAL
            state_node.viz["fillcolor"] = NODE_COLOR_ROUTE_GOAL
          end

          if passenger
            if !passenger_hit && !(passenger.state_history & line.send("#{state.downcase}ed")).empty?
              passenger_hit = true
              state_node.viz["color"] = NODE_COLOR_PASSENGER_HIT
              state_node.viz["penwidth"] = NODE_PENWIDTH_PASSENGER_HIT
            end
          end
        end
      end

      route.connections.each do |connection|
        to_node = g.find(connection.line)
        to_line = to_node.base

        combos = {}
        g.to_a.each do |node|
          states = node.base.state_names(connection.states)
          states.each do |state|
            (combos[state] ||= []) << node
          end
        end

        if connection.type == :if_any
          combos.each do |state, nodes|
            nodes.each do |node|
              from_line = node.base
              g.viz.add_edges(
                node.viz.get_node("#{from_line.class.name}#{state}"),
                to_node.viz.get_node("#{to_line.class.name}PASS"),
                "lhead" => to_node.viz.id
              )
            end
          end
        end

        if connection.type == :if_all
          combos.each do |state, nodes|
            node_name = nodes.map{ |n| n.base.class.name }.join + state
            node_label = nodes.map{ |n| "#{n.base.class.name} #{state}"}.join("\n")
            viz = g.viz.add_nodes(node_name, "label" => node_label)
            viz["style"] = NODE_STYLE_VIRTUAL
            viz["color"] = NODE_COLOR_VIRTUAL
            viz["fontcolor"] = NODE_FONTCOLOR_VIRTUAL

            nodes.each do |node|
              from_viz = node.viz.get_node("#{node.base.class.name}#{state}")
              g.viz.add_edges from_viz, viz
            end

            g.viz.add_edges(
              viz,
              to_node.viz.get_node("#{connection.line.class.name}#{state}"),
              "lhead" => to_node.viz.id
            )
          end
        end
      end

      file_name = "#{route.name.downcase.gsub("::", "_")}-route-basic.#{format}"
      g.viz.output(format => File.join(dir, file_name))
    end

    def graph_route(passenger=nil)
      g = Node.new(nil, GraphViz.new("GraphRoute"))
      set_graph_defaults g.viz
      g.viz["label"] = "#{route.name} Lines"
      g.viz["ranksep"] = 0.8

      route.lines.each_with_index do |line, index|
        line_cluster = Node.new(line, g.viz.add_graph("cluster#{index}"))
        set_cluster_defaults line_cluster.viz
        line_cluster.viz["label"] = line.class.name
        g << line_cluster

        line.states.keys.each do |state|
          state_node = Node.new(state, line_cluster.viz.add_nodes(state))
          if line.goal.include?(state)
            state_node.viz["color"] = NODE_COLOR_LINE_GOAL
            state_node.viz["fillcolor"] = NODE_FILLCOLOR_LINE_GOAL
          end
          if route.goal.include?(state)
            state_node.viz["color"] = NODE_COLOR_ROUTE_GOAL
            state_node.viz["fillcolor"] = NODE_FILLCOLOR_ROUTE_GOAL
          end
          if passenger && passenger.state_history_includes?(state)
            state_node.viz["color"] = NODE_COLOR_PASSENGER_HIT
            state_node.viz["penwidth"] = NODE_PENWIDTH_PASSENGER_HIT
          end
          line_cluster << state_node
        end
      end

      viz = g.viz.add_nodes(route.initial_state)
      rendered_edges = {}

      if passenger
        passenger_nodes = g.reduce([]) do |memo, line_cluster| 
          line_cluster.children.each do |node| 
            if node.viz["color"].to_s.gsub(/\W/, "") == NODE_COLOR_PASSENGER_HIT
              memo << node
            end
          end
          memo
        end
        previous_node = nil
        passenger_nodes.each do |node|
          from_viz = previous_node.nil? ? viz : previous_node.viz
          rendered_edges[from_viz.id + node.viz.id] = true
          edge = g.viz.add_edges(from_viz, node.viz)
          edge["color"] = EDGE_COLOR_PASSENGER_HIT
          edge["penwidth"] = EDGE_PENWIDTH_PASSENGER_HIT
          previous_node = node
        end
      end

      route.states.each do |from_state, to_states|
        (to_states || []).each do |to_state|
          from_line = route.lines.to_a.select{ |l| l.states.keys.include?(from_state) }.first
          from_node = g.find(from_line) if from_line
          from_viz = from_node.viz.get_node(from_state) if from_node
          from_viz ||= g.viz.get_node(from_state)
          to_line = route.lines.to_a.select{ |l| l.states.keys.include?(to_state) }.first
          to_node = g.find(to_line) if to_line
          to_viz = to_node.viz.get_node(to_state) if to_node
          to_viz ||= g.viz.get_node(to_state)

          if from_viz && to_viz && !rendered_edges[from_viz.id + to_viz.id]
            rendered_edges[from_viz.id + to_viz.id] = true
            edge = g.viz.add_edges(
              from_viz,
              to_viz
            )
            edge["style"] = EDGE_STYLE_PASSENGER_MISS if passenger
          end
        end
      end

      file_name = "#{route.name.downcase.gsub("::", "_")}-route.#{format}"
      g.viz.output(format => File.join(dir, file_name))
    end

    private

    def set_graph_defaults(graph)
      graph["compound"] = true
      graph["ranksep"] = RANKSEP
      graph["fontname"] = FONTNAME
      graph.node["fontname"] = FONTNAME
      graph.node["shape"] = NODE_SHAPE
      graph.node["style"] = NODE_STYLE
      graph.node["color"] = NODE_COLOR
      graph.node["fillcolor"] = NODE_FILLCOLOR
    end

    def set_cluster_defaults(cluster)
      cluster["style"] = CLUSTER_STYLE
      cluster["color"] = CLUSTER_COLOR
      cluster["fillcolor"] = CLUSTER_FILLCOLOR
      cluster["pencolor"] = CLUSTER_PENCOLOR
    end

  end
end
