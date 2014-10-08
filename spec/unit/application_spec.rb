require_relative '../spec_helper'
require_relative '../../circular_dep_app/application'

module CircularDepApp

  describe Application do

    let(:cmd_line_args) { [] }

    describe :run do
      let(:parsed_opts) { {} }
      let(:graph) { double 'My Graph' }
      let(:analyzer) { double('Circular Dep Analyzer').as_null_object }

      before :each do
        allow(Application).to receive(:parse_command_line_opts).and_return parsed_opts
        allow(GraphFactory).to receive(:from_file).and_return graph
        allow(GraphAnalysis::CircularDependency::Analyzer).to receive(:new).and_return analyzer
        allow(GraphAnalysis::CircularDependency::ResultTextRenderer).to receive :render_result
      end

      subject { Application.run cmd_line_args}

      it 'parses the command line options' do
        expect(Application).to receive(:parse_command_line_opts).with cmd_line_args
        subject
      end

      it 'creates a new graph from the input file' do
        expected_input_file = 'just a file'
        parsed_opts[:input_file] = expected_input_file
        expect(GraphFactory).to receive(:from_file).with expected_input_file

        subject
      end

      it 'creates a new analyzer for circular dependencies' do
        expect(GraphAnalysis::CircularDependency::Analyzer).to receive :new
        subject
      end

      it 'analyzes the graph for circular dependencies' do
        new_graph = 'The new graph'
        allow(GraphFactory).to receive(:from_file).and_return new_graph
        expect(analyzer).to receive(:analyze).with new_graph

        subject
      end

      it 'renders the result of the analysis' do
        results = 'Some results'
        allow(analyzer).to receive(:analyze).and_return results
        expect(GraphAnalysis::CircularDependency::ResultTextRenderer).to receive(:render_result).with results, $stdout

        subject
      end
    end

    describe :parse_command_line_opts do

      subject { Application.parse_command_line_opts cmd_line_args}

      it 'returns the input file path' do
        expected_file_name = 'Input File Name'
        cmd_line_args << expected_file_name
        expect(subject).to include({input_file: expected_file_name})
      end

      it 'raises exception when no input file path' do
        expect{subject}.to raise_error 'Wrong number of arguments'
      end

      it 'raises exception when too many params are provided' do
        cmd_line_args.concat ['file1', 'file2']
        expect{subject}.to raise_error 'Wrong number of arguments'
      end
    end
  end
end