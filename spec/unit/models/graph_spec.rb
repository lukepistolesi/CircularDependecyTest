require_relative '../../spec_helper'
require_relative '../../../circular_dep_app/models/graph'
require_relative '../../../circular_dep_app/models/node'

module CircularDepApp::Models
  describe Graph do

    describe :initialize do
      it 'allocates empty collections of nodes' do
        graph = Graph.new
        expect(graph.nodes).to be_empty
        expect(graph.node_names).to be_empty
      end
    end

    describe :add_arch do

      let(:graph) { Graph.new }
      let(:node) { 'N1' }
      let(:other) { 'O1' }
      let(:type) { Graph::ARCH_TYPE_HOLD }

      before :each do
        allow(graph).to receive(:find_or_add_node).and_return double.as_null_object
      end

      subject { graph.add_arch node, other, type }

      it 'adds or finds a new node for the first node param' do
        expect(graph).to receive(:find_or_add_node).with node
        subject
      end

      it 'adds or finds a new node for other node param' do
        expect(graph).to receive(:find_or_add_node).with other
        subject
      end

      context 'arch type' do

        let(:st_node) { double Node }
        let(:nd_node) { double Node }

        before :each do
          allow(graph).to receive(:find_or_add_node).with(node).and_return st_node
          allow(graph).to receive(:find_or_add_node).with(other).and_return nd_node
        end

        it 'ads the second param node as outbound in the first param node' do
          allow(nd_node).to receive :add_inbound
          expect(st_node).to receive(:add_outbound).with nd_node
          graph.add_arch node, other, Graph::ARCH_TYPE_HOLD
        end

        it 'ads the first param node as inbound in the second param node' do
          allow(st_node).to receive :add_outbound
          expect(nd_node).to receive(:add_inbound).with st_node
          graph.add_arch node, other, Graph::ARCH_TYPE_HOLD
        end

        it 'ads the first param node as outbound in the second param node' do
          allow(st_node).to receive :add_inbound
          expect(nd_node).to receive(:add_outbound).with st_node
          graph.add_arch node, other, Graph::ARCH_TYPE_WAIT
        end

        it 'ads the second param node as inbound in the first param node' do
          allow(nd_node).to receive :add_outbound
          expect(st_node).to receive(:add_inbound).with nd_node
          graph.add_arch node, other, Graph::ARCH_TYPE_WAIT
        end

        it 'raises an exception when the type is unknown' do
          expect{ graph.add_arch node, other, 'Unknown' }.to raise_error "Arch type 'Unknown' not supported"
        end
      end
    end

    describe :find_or_add_node do

      let(:node_name) { 'Name' }
      let(:mocked_node) { double Node }
      let(:graph) { Graph.new }

      before :each do
        allow(Node).to receive(:new).and_return mocked_node
      end

      subject{ graph.send :find_or_add_node, node_name }

      it 'allocates a new node' do
        expect(Node).to receive(:new).with node_name
        subject
      end

      it 'adds the new node to the node collection' do
        subject
        expect(graph.nodes).to include mocked_node
      end

      it 'maps the new node with its name' do
        subject
        expect(graph.node_names).to eql [node_name]
      end

      it 'returns the newly created node' do
        expect(subject).to eql mocked_node
      end

      context 'nodes collection not empty' do

        before :each do
          graph.send :find_or_add_node, node_name
        end

        it 'does not allocate a new node' do
          expect(Node).not_to receive :new
          subject
        end

        it 'returns the existing node' do
          expect(subject).to eql mocked_node
          subject
        end
      end
    end

    describe :node_names do
      it 'returns empty names' do
        expect(Graph.new.node_names).to be_empty
      end

      it 'returns the names of the current nodes' do
        allow(Node).to receive :new
        graph = Graph.new
        graph.send :find_or_add_node, 'Node1'
        graph.send :find_or_add_node, 'Node2'

        expect(graph.node_names).to eql ['Node1', 'Node2']
      end
    end
  end
end
