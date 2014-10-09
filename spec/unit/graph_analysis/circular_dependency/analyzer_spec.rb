require_relative '../../../spec_helper'
require_relative '../../../../circular_dep_app/graph_analysis/circular_dependency/analyzer'

module CircularDepApp::GraphAnalysis::CircularDependency

  describe Analyzer do

    describe :analyze do

      let(:nodes) { ['Node1'] }
      let(:graph) { double CircularDepApp::Models::Graph, nodes: nodes }
      let(:results) { double AnalysisResult }
      let(:dependency) { ['List of nodes for the dependency'] }
      let(:analyzer) { Analyzer.new }

      before :each do
        allow(AnalysisResult).to receive(:new).and_return results
        allow(analyzer).to receive(:find_dependency).and_return dependency
        allow(results).to receive :dependency=
      end

      subject { analyzer.analyze graph}

      it 'creates a result object' do
        expect(AnalysisResult).to receive :new
        subject
      end

      it 'returns an empty result when empty graph' do
        nodes.clear
        expect(subject).to eql results
      end

      it 'finds dependencies when nodes' do
        expect(analyzer).to receive(:find_dependency).with nodes
        subject
      end

      it 'sets the discovered dependency in the result' do
        expect(results).to receive(:dependency=).with dependency
        subject
      end

      it 'returns the result object when dependency found' do
        expect(subject).to eql results
      end
    end

    describe :find_dependency do
      let(:node1) { double 'Node1' }
      let(:nodes) { Set.new [node1] }
      let(:markers) { {} }
      let(:analyzer) { Analyzer.new }

      before :each do
        allow(analyzer).to receive :crawl_inbounds
        analyzer.instance_variable_set(:@markers, markers)
      end

      subject { analyzer.send :find_dependency, nodes }

      it 'returns an empty chain when no nodes' do
        nodes.clear
        expect(subject).to be_empty
      end

      it 'resets the node markers for each node' do
        nodes << double('Node2')
        expect(markers).to receive(:clear).twice
        subject
      end

      it 'sets a marker for each node with an increasing id' do
        analyzer.instance_variable_set :@crawl_id, 1234
        expect(markers).to receive(:[]=).with node1, 1234 + 1
        subject
      end

      it 'crawls the inbounds of each node' do
        expect(analyzer).to receive(:crawl_inbounds).with node1, anything
        subject
      end

      it 'crawls the inbounds of each node with the incremental id' do
        analyzer.instance_variable_set :@crawl_id, 1234
        expect(analyzer).to receive(:crawl_inbounds).with anything, 1234 + 1
        subject
      end

      it 'returns the node chain if a loop is detected' do
        chain = ['A chain of nodes']
        allow(analyzer).to receive(:crawl_inbounds).and_return chain
        expect(subject).to eql chain
      end

      it 'returns an empty node chain if a loop is not detected' do
        allow(analyzer).to receive(:crawl_inbounds).and_return nil
        expect(subject).to be_empty
      end
    end

    describe :crawl_inbounds do

      let(:inbound_node) { double 'In Node' }
      let(:inbounds) { [inbound_node] }
      let(:node) { double 'Node', inbounds: inbounds }
      let(:crawl_id) { 12333 }
      let(:markers) { {} }
      let(:analyzer) { Analyzer.new }

      before :each do
        allow(analyzer).to receive(:crawl_inbounds).with(node, crawl_id).and_call_original
        analyzer.instance_variable_set(:@markers, markers)
      end

      subject { analyzer.send :crawl_inbounds, node, crawl_id }

      it 'returns nil when no inbounds' do
        inbounds.clear
        expect(subject).to be_nil
      end

      it 'returns the inbound node if it has been marked with same id' do
        markers[inbound_node] = crawl_id
        expect(subject).to eql [inbound_node]
      end

      it 'adds a marker for the new not marked inbound node' do
        allow(analyzer).to receive(:crawl_inbounds).with inbound_node, crawl_id
        allow(markers).to receive(:[]=).with inbound_node, nil
        expect(markers).to receive(:[]=).with inbound_node, crawl_id
        subject
      end

      it 'crawls the inbound node with the current id' do
        expect(analyzer).to receive(:crawl_inbounds).with inbound_node, crawl_id
        subject
      end

      it 'returns the node chain if the inbound crawling returns one' do
        allow(analyzer).to receive(:crawl_inbounds).with(inbound_node, crawl_id).and_return ['My Chain']
        expect(subject).to eql ['My Chain', inbound_node]
      end

      it 'clears the marker for the current node when no chain detected' do
        allow(analyzer).to receive(:crawl_inbounds).with(inbound_node, crawl_id).and_return nil
        allow(markers).to receive(:[]=).with inbound_node, crawl_id
        expect(markers).to receive(:[]=).with inbound_node, nil
        subject
      end

      it 'returns nothing if no chain found' do
        allow(analyzer).to receive(:crawl_inbounds).with(inbound_node, crawl_id).and_return nil
        expect(subject).to be_nil
      end

    end

  end
end

