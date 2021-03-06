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

      def add(node)
        self << node
        node
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

    attr_reader :route, :format, :short_names

    def initialize(route, format: :svg, short_names: true)
      @route = route
      @format = format
      @short_names = short_names
    end

    FONTNAME                    = "Helvetica"
    RANKSEP                     = 0.4
    NODE_COLOR                  = "white"
    NODE_COLOR_VIRTUAL          = "gray50"
    NODE_COLOR_LINE_GOAL        = "green2"
    NODE_COLOR_ROUTE_GOAL       = "gold"
    NODE_COLOR_PASSENGER_HIT    = "royalblue1"
    NODE_FILLCOLOR              = "white"
    NODE_FILLCOLOR_LINE_GOAL    = "green2"
    NODE_FILLCOLOR_ROUTE_GOAL   = "gold"
    NODE_FONTCOLOR_VIRTUAL      = "gray40"
    NODE_SHAPE                  = "box"
    NODE_STYLE                  = "filled,rounded"
    NODE_STYLE_VIRTUAL          = "rounded"
    NODE_PENWIDTH_PASSENGER_HIT = 2
    EDGE_PENWIDTH_PASSENGER_HIT = 2
    EDGE_COLOR_PASSENGER_HIT    = "royalblue1"
    EDGE_STYLE_PASSENGER_MISS   = "dotted"
    CLUSTER_STYLE               = "filled"
    CLUSTER_COLOR               = "gray70"
    CLUSTER_FILLCOLOR           = "gray70"
    CLUSTER_PENCOLOR            = "gray50"

    def class_label(obj)
      klass = obj
      klass = klass.class unless klass.is_a?(Class)
      return klass.name unless short_names
      klass.name.split("::").last
    end

    def state_label(state)
      return state unless short_names
      state.split(" ").map { |part| part.split("::").last }.join(" | ")
    end

    def graph_route_basic(passenger=nil)
      g = Node.new(nil, GraphViz.new("GraphRouteBasic"))
      set_graph_defaults g.viz
      g.viz[:ranksep] = 1
      g.viz[:label] = "#{class_label(route)} Route - basic"

      route.lines.each_with_index do |line, index|
        line_cluster = g.add(Node.new(line, g.viz.add_graph("cluster#{index}")))
        set_cluster_defaults line_cluster.viz
        line_cluster.viz[:label] = class_label(line)

        %w{PASS FAIL ERROR}.each do |state|
          state_node = line_cluster.add(Node.new(state, line_cluster.viz.add_nodes("#{line.class.name}#{state}", "label" => state)))
          states = line.stations.map{ |s| "#{state} #{s.name}" }
          style_node_for_line(state_node, line, *states)
          style_node_for_route(state_node, route, *states)
          style_node_for_passenger(state_node, passenger, *line.send("#{state.downcase}ed"))
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

        if connection.strict
          combos.each do |state, nodes|
            node_name = nodes.map{ |n| n.base.class.name }.join + state
            node_label = nodes.map{ |n| state_label(state) }.join("\n")
            viz = g.viz.add_nodes(node_name, :label => node_label)
            g.viz.add_edges(
              viz,
              to_node.viz.get_node("#{connection.line.class.name}#{state}"),
              "lhead" => to_node.viz.id
            )
          end
        else
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
      end

      g.viz.output(format => String)
    end

    def graph_route(passenger=nil)
      g = Node.new(nil, GraphViz.new("GraphRoute"))
      set_graph_defaults g.viz
      g.viz[:label] = "#{class_label(route)} Lines"
      g.viz[:ranksep] = 0.8

      route.lines.each_with_index do |line, index|
        line_cluster = g.add(Node.new(line, g.viz.add_graph("cluster#{index}")))
        set_cluster_defaults line_cluster.viz
        line_cluster.viz[:label] = class_label(line)
        add_state_nodes_for_line line_cluster, line, passenger
      end

      viz = g.viz.add_nodes(route.initial_state, :label => state_label(route.initial_state))
      rendered_edges = {}

      if passenger
        passenger_nodes = g.reduce([]) do |memo, line_cluster|
          line_cluster.children.each do |node|
            if node.viz[:color].to_s.gsub(/\W/, "") == NODE_COLOR_PASSENGER_HIT
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
            edge[:style] = EDGE_STYLE_PASSENGER_MISS if passenger
          end
        end
      end

      g.viz.output(format => String)
    end

    protected

    def add_state_nodes_for_line(cluster, line, passenger)
      line.states.keys.each do |state|
        node = cluster.add(Node.new(state, cluster.viz.add_nodes(state, :label => state_label(state))))
        style_node_for_line(node, line, state)
        style_node_for_route(node, route, state)
        style_node_for_passenger(node, passenger, state)
      end
    end

    def style_node(node, color)
      node.viz[:color] = color
      node.viz[:fillcolor] = color
    end

    def style_node_for_line(node, line, *states)
      return if (line.goal & states).empty?
      style_node node, NODE_COLOR_LINE_GOAL
    end

    def style_node_for_route(node, route, *states)
      return if (route.goal & states).empty?
      style_node node, NODE_COLOR_ROUTE_GOAL
    end

    def style_node_for_passenger(node, passenger, *states)
      return if passenger.nil?
      return if (passenger.state_history & states).empty?
      node.viz[:color] = NODE_COLOR_PASSENGER_HIT
      node.viz[:penwidth] = NODE_PENWIDTH_PASSENGER_HIT
    end

    def color_name(graphviz_color)
      graphviz_color.to_s.gsub("\"", "")
    end

    def set_graph_defaults(graph)
      graph[:compound]       = true
      graph[:ranksep]        = RANKSEP
      graph[:fontname]       = FONTNAME
      graph.node[:fontname]  = FONTNAME
      graph.node[:shape]     = NODE_SHAPE
      graph.node[:style]     = NODE_STYLE
      graph.node[:color]     = NODE_COLOR
      graph.node[:fillcolor] = NODE_FILLCOLOR
    end

    def set_cluster_defaults(cluster)
      cluster[:style]     = CLUSTER_STYLE
      cluster[:color]     = CLUSTER_COLOR
      cluster[:fillcolor] = CLUSTER_FILLCOLOR
      cluster[:pencolor]  = CLUSTER_PENCOLOR
    end

  end
end
