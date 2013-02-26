require "graphviz"

module Ellington
  class Visualizer

    attr_reader :route

    def initialize(route)
      @route = route
    end

    def graph
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

  end

end
