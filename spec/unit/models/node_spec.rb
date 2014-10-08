require_relative '../../spec_helper'
require_relative '../../../circular_dep_app/models/node'

module CircularDepApp::Models
  describe Node do
    describe :initialize do

      it 'sets the node name' do
        node = Node.new 'My Name'
        expect(node.name).to eql 'My Name'
      end

      it 'sets the outbound collection to empty' do
        node = Node.new 'My Name'
        expect(node.outbounds).to be_empty
      end

      it 'sets the inbound collection to empty' do
        node = Node.new 'My Name'
        expect(node.inbounds).to be_empty
      end
    end

    describe :add_outbound do

      let(:other_node) { 'Other' }
      let(:node) { Node.new 'A Name' }

      subject { node.add_outbound other_node }

      it 'adds the given node to the list of the outbound nodes' do
        subject
        expect(node.outbounds).to eql Set.new([other_node])
      end

      it 'does nto add twice the same node' do
        node.add_outbound other_node
        subject
        expect(node.outbounds).to eql Set.new([other_node])
      end

      it 'raises exception when no node provided' do
        expect{node.add_outbound nil}.to raise_error 'No node provided'
      end
    end

    describe :add_inbound do

      let(:other_node) { 'Other' }
      let(:node) { Node.new 'A Name' }

      subject { node.add_inbound other_node }

      it 'adds the given node to the list of the inbound nodes' do
        subject
        expect(node.inbounds).to eql Set.new([other_node])
      end

      it 'does nto add twice the same node' do
        node.add_inbound other_node
        subject
        expect(node.inbounds).to eql Set.new([other_node])
      end

      it 'raises exception when no node provided' do
        expect{node.add_inbound nil}.to raise_error 'No node provided'
      end
    end

  end
end