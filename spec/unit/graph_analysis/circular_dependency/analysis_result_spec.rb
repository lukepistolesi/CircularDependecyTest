require_relative '../../../spec_helper'
require_relative '../../../../circular_dep_app/graph_analysis/circular_dependency/analysis_result'

module CircularDepApp::GraphAnalysis::CircularDependency

  describe AnalysisResult do

    describe :dependency= do
      it 'sets the dependency variable' do
        dep_chain = ['My Chain']
        result = AnalysisResult.new
        result.dependency = dep_chain
        expect(result.dependency).to eql dep_chain
      end
    end

    describe :dependency_detected? do
      it 'returns false when no dependency defined' do
        expect(AnalysisResult.new.dependency_detected?).to eql false
      end

      it 'returns false when empty dependency chain' do
        result = AnalysisResult.new
        result.dependency = []
        expect(result.dependency_detected?).to eql false
      end
    end

  end
end
