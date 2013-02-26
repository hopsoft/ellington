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

      route.lines.each do |line|
        nodes[line] ||= {}
        nodes[line]["PASS"] = g.add_nodes("#{line.class.name} [PASS]")
        nodes[line]["PASS"].color = "green"
        nodes[line]["FAIL"] = g.add_nodes("#{line.class.name} [FAIL]")
        nodes[line]["ERROR"] = g.add_nodes("#{line.class.name} [ERROR]")
      end

      route.lines.each do |line|
        g.add_edges nodes[line]["ERROR"], nodes[line]["PASS"]
        g.add_edges nodes[line]["ERROR"], nodes[line]["FAIL"]
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
            elsif (connection.states & line.failed).length == line.passed.length
              g.add_edges nodes[line]["FAIL"], nodes[connection.line]["PASS"]
              g.add_edges nodes[line]["FAIL"], nodes[connection.line]["FAIL"]
              g.add_edges nodes[line]["FAIL"], nodes[connection.line]["ERROR"]
            elsif (connection.states & line.errored).length == line.passed.length
              g.add_edges nodes[line]["ERROR"], nodes[connection.line]["PASS"]
              g.add_edges nodes[line]["ERROR"], nodes[connection.line]["FAIL"]
              g.add_edges nodes[line]["ERROR"], nodes[connection.line]["ERROR"]
            end
          end
        end
      end

      route.connections.each do |connection|
        if connection.type == :if_all
          lines = {}
          route.lines.each do |line|
            if (connection.states & line.passed).length == line.passed.length
              (lines["PASS"] ||= []) << line
            elsif (connection.states & line.failed).length == line.passed.length
              (lines["FAIL"] ||= []) << line
            elsif (connection.states & line.errored).length == line.passed.length
              (lines["ERROR"] ||= []) << line
            end
          end
        end
      end

      g.output(:pdf => "#{route.name}.pdf")
    end

  end

end
