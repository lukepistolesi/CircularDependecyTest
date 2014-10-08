require_relative '../../../spec_helper'
require_relative '../../../../circular_dep_app/graph_analysis/circular_dependency/analyzer'

module CircularDepApp::GraphAnalysis::CircularDependency

  describe Analyzer do

    describe :find_dependency do
      let(:inbounds1) { [] }
      let(:inbounds2) { [] }
      let(:inbounds3) { [] }
      let(:inbounds4) { [] }
      let(:node1) { double('Node1', inbounds: inbounds1).as_null_object }
      let(:node2) { double('Node2', inbounds: inbounds2).as_null_object }
      let(:node3) { double('Node3', inbounds: inbounds3).as_null_object }
      let(:node4) { double('Node4', inbounds: inbounds4).as_null_object }
      let(:nodes) { Set.new }

      subject { Analyzer.new.send :find_dependency, nodes }

      it 'returns an empty chain when single node' do
        nodes << node1
        expect(subject).to be_empty
      end

      it 'returns an empty chain when node with two inbounds' do
        inbounds1.concat [node2, node3]
        nodes.merge [node1, node2]
        expect(subject).to be_empty
      end

      it 'returns an empty chain when one open chain' do
        inbounds1 << node2
        inbounds3 << node1
        nodes.merge [node1, node2, node3]
        expect(subject).to be_empty
      end

      it 'two nodes loop' do
        inbounds1 << node2
        inbounds2 << node1
        nodes.merge [node1, node2]
        expect(subject).to eql [node1, node2]
      end

      it 'two nodes loop and an open chain' do
        inbounds1 << node2
        inbounds2 << node1
        inbounds3 << node4
        nodes.merge [node1, node2, node3, node4]
        expect(subject).to eql [node1, node2]
      end
    end
  end
end

