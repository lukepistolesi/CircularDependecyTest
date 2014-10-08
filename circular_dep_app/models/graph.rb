require 'set'
require_relative 'node'

module CircularDepApp
  module Models

    class Graph

      ARCH_TYPE_HOLD = 'H'
      ARCH_TYPE_WAIT = 'W'

      def nodes; @nodes end
      def node_names; @node_names.keys end

      def initialize
        @nodes = Set.new
        @node_names = {}
      end

      def add_arch(node_name, other_node_name, type)
        node = find_or_add_node node_name
        other = find_or_add_node other_node_name
        case type
          when ARCH_TYPE_HOLD
            node.add_outbound other
            other.add_inbound node
          when ARCH_TYPE_WAIT
            other.add_outbound node
            node.add_inbound other
          else
            raise "Arch type '#{type}' not supported"
        end
      end

    private

      def find_or_add_node(node_name)
        if node = @node_names[node_name]
          return node
        end
        node = Node.new node_name
        @nodes << node
        @node_names[node_name] = node
      end
    end

  end
end
