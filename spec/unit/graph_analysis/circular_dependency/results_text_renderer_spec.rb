require_relative '../../../spec_helper'
require_relative '../../../../circular_dep_app/graph_analysis/circular_dependency/results_text_renderer'

module CircularDepApp::GraphAnalysis::CircularDependency

  describe ResultTextRenderer do
    describe :render_result do

      let(:dependency) { double AnalysisResult }
      let(:output) { double IO }

      it 'renders a good string when no dependency detected' do
        allow(dependency).to receive(:dependency_detected?).and_return false
        expect(output).to receive(:puts).with 'GOOD'
        ResultTextRenderer.render_result dependency, output
      end

      it 'renders a bad string when dependency detected' do
        allow(dependency).to receive(:dependency_detected?).and_return true
        expect(output).to receive(:puts).with 'BAD'
        ResultTextRenderer.render_result dependency, output
      end
    end
  end
end