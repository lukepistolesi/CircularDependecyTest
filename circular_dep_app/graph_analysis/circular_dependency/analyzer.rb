require 'set'
require_relative 'analysis_result'
require_relative '../../models/graph'
require_relative '../../models/node'

module CircularDepApp::GraphAnalysis
  module CircularDependency

    class Analyzer

      def initialize
        @markers = {}
        @crawl_id = 0
      end

      def analyze(graph)
        results = AnalysisResult.new
        return results if graph.nodes.empty?
        dependency = find_dependency graph.nodes
        results.dependency = dependency
        results
      end


    private

      def find_dependency(nodes)
        nodes.each do |node|
          @markers.clear
          crawl_id = @crawl_id += 1
          @markers[node] = crawl_id
          node_cahin = crawl_inbounds node, crawl_id
          return node_cahin if node_cahin
        end
        []
      end

      def crawl_inbounds(node, id)
        node.inbounds.each do |inbound|
          return [inbound] if @markers[inbound] == id
          @markers[inbound] = id
          node_chain = crawl_inbounds inbound, id
          return node_chain << inbound if node_chain
        end
        nil
      end

    end

  end
end
