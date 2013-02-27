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
      g = Node.new(nil, GraphViz.new("G"))
      g.viz.output(:pdf => "#{route.name}.pdf")
    end

    def graph_lines_basic
      g = Node.new(nil, GraphViz.new("G"))
      g.viz["label"] = "#{route.name} Lines - basic"
      g.viz["ranksep"] = 0.4
      g.viz["fontname"] = "Helvetica"
      g.viz.node["fontname"] = "Helvetica"
      g.viz.node["shape"] = "box"
      g.viz.node["style"] = "rounded"

      route.lines.each_with_index do |line, index|
        line_cluster = Node.new(line, g.viz.add_graph("cluster#{index}"))
        line_cluster.viz["label"] = line.class.name
        line_cluster.viz["style"] = "filled"
        g << line_cluster

        line.stations.each do |station|
          station_node = Node.new(station, line_cluster.viz.add_nodes(station.class.name))
          station_node.viz["style"] = "filled,rounded"
          station_node.viz["color"] = "white"
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
      g = Node.new(nil, GraphViz.new("G"))
      g.viz["label"] = "#{route.name} Lines"
      g.viz["ranksep"] = 0.4
      g.viz["fontname"] = "Helvetica"
      g.viz.node["fontname"] = "Helvetica"
      g.viz.node["shape"] = "box"
      g.viz.node["style"] = "rounded"

      route.lines.each_with_index do |line, index|
        line_cluster = Node.new(line, g.viz.add_graph("cluster#{index}"))
        line_cluster.viz["label"] = line.class.name
        line_cluster.viz["style"] = "filled"
        g << line_cluster

        line.states.keys.each do |state|
          state_node = Node.new(state, line_cluster.viz.add_nodes(state))
          state_node.viz["style"] = "filled,rounded"
          state_node.viz["color"] = "white"
          if line.goal.include?(state)
            state_node.viz["color"] = "green2"
          end
          if route.goal.include?(state)
            state_node.viz["color"] = "gold"
          end
          line_cluster << state_node
        end

        line.states.each do |state, transitions|
          a = line_cluster.find(state)
          (transitions || []).each do |transition|
            b = line_cluster.find(transition)
            line_cluster.viz.add_edges a.viz, b.viz
          end
        end
      end

      g.viz.output(:pdf => "#{route.name}.pdf")
    end

    def graph_route_basic
      g = Node.new(nil, GraphViz.new("G"))
      g.viz["label"] = "#{route.name} Route - basic"
      g.viz["compound"] = true
      g.viz["ranksep"] = 1.2
      g.viz["fontname"] = "Helvetica"
      g.viz.node["fontname"] = "Helvetica"
      g.viz.node["shape"] = "box"
      g.viz.node["style"] = "rounded"

      route.lines.each_with_index do |line, index|
        line_cluster = Node.new(line, g.viz.add_graph("cluster#{index}"))
        line_cluster.viz["label"] = line.class.name
        line_cluster.viz["style"] = "filled"
        g << line_cluster

        %w{PASS FAIL ERROR}.each do |state|
          state_node = Node.new(state, line_cluster.viz.add_nodes("#{line.class.name}#{state}", "label" => state))
          state_node.viz["style"] = "filled,rounded"
          state_node.viz["color"] = "white"
          if !(route.goal & line.stations.map{ |s| "#{state} #{s.name}" }).empty?
            state_node.viz["color"] = "gold"
          end
          line_cluster << state_node
        end
      end

      route.connections.each do |connection|
        to_node = g.find(connection.line)
        from_line = to_node.base

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
              to_line = node.base
              g.viz.add_edges(
                node.viz.get_node("#{to_line.class.name}#{state}"),
                to_node.viz.get_node("#{from_line.class.name}PASS"),
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
            viz["style"] = "rounded"
            viz["color"] = "gray50"
            viz["fontcolor"] = "gray40"

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

      g.viz.output(:pdf => "#{route.name}.pdf")
    end

    def graph_route
      g = Node.new(nil, GraphViz.new("G"))
      g.viz["label"] = "#{route.name} Lines"
      g.viz["compound"] = true
      g.viz["ranksep"] = 0.8
      g.viz["fontname"] = "Helvetica"
      g.viz.node["fontname"] = "Helvetica"
      g.viz.node["shape"] = "box"
      g.viz.node["style"] = "rounded"

      route.lines.each_with_index do |line, index|
        line_cluster = Node.new(line, g.viz.add_graph("cluster#{index}"))
        line_cluster.viz["label"] = line.class.name
        line_cluster.viz["style"] = "filled"
        g << line_cluster

        line.states.keys.each do |state|
          state_node = Node.new(state, line_cluster.viz.add_nodes(state))
          state_node.viz["style"] = "filled,rounded"
          state_node.viz["color"] = "white"
          if line.goal.include?(state)
            state_node.viz["color"] = "green2"
          end
          if route.goal.include?(state)
            state_node.viz["color"] = "gold"
          end
          line_cluster << state_node
        end
      end

      viz = g.viz.add_nodes(route.initial_state)

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

          if from_viz && to_viz
            g.viz.add_edges(
              from_viz,
              to_viz
            )
          end
        end
      end

      g.viz.output(:pdf => "#{route.name}.pdf")
    end

  end
end
