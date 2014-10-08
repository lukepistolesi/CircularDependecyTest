module CircularDepApp::GraphAnalysis
  module CircularDependency

    class ResultTextRenderer
      def self.render_result(analysis_result, output)
        if analysis_result.dependency_detected?
          output.puts 'BAD'
        else
          output.puts 'GOOD'
        end
      end
    end

  end
end
