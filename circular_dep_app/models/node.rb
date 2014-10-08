require 'set'

module CircularDepApp
  module Models

    class Node

      def name; @name end
      def outbounds; @outbounds end
      def inbounds; @inbounds end

      def initialize(node_name)
        @name = node_name
        @outbounds = Set.new
        @inbounds = Set.new
      end

      def add_outbound(node)
        raise 'No node provided' if node.nil?
        @outbounds << node
      end

      def add_inbound(node)
        raise 'No node provided' if node.nil?
        @inbounds << node
      end

    end

  end
end
