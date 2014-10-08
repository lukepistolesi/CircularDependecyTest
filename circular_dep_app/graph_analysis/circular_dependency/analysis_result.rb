module CircularDepApp
  module GraphAnalysis
    module CircularDependency

      class AnalysisResult
        def dependency_detected?
          !!(@dependency && !@dependency.empty?)
        end

        def dependency=(dependency)
          @dependency = dependency
        end

        def dependency; @dependency end
      end

    end
  end
end