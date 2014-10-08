require_relative '../spec_helper'
require_relative '../../circular_dep_app/graph_factory'

module CircularDepApp

  describe GraphFactory do

    describe :from_file do

      let(:file_path) { 'File Path' }
      let(:file_lines) { [] }
      let(:mocked_graph) { double Models::Graph }

      before :each do
        allow(Models::Graph).to receive(:new).and_return mocked_graph
        allow(File).to receive(:readlines).and_return file_lines
      end

      subject { GraphFactory.from_file file_path }

      it 'creates a new graph' do
        expect(Models::Graph).to receive :new
        subject
      end

      it 'reads the file' do
        expect(File).to receive(:readlines).with file_path
        subject
      end

      it 'reads all the lines of the files' do
        expect(file_lines).to receive(:each)
        subject
      end

      it 'adds a new node with the information from the line' do
        source, dest, type = 'S1', 'D1', 'H'
        file_lines << source + ',' + dest + ',' + type
        expect(mocked_graph).to receive(:add_arch).with source, dest, type

        subject
      end

      it 'returns the newly created graph' do
        expect(subject).to eql mocked_graph
      end
    end

  end
end
