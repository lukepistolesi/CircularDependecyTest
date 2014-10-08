require 'optparse'
Dir['./circular_dep_app/**/*.rb'].each { |f| require f }

module CircularDepApp
  class Application
    def self.run(args)
      options = parse_command_line_opts args
      graph = GraphFactory.from_file options[:input_file]
      analysis_result = GraphAnalysis::CircularDependency::Analyzer.new.analyze graph
      GraphAnalysis::CircularDependency::ResultTextRenderer.render_result analysis_result, $stdout
    end

    def self.parse_command_line_opts(args)
      raise 'Wrong number of arguments' if args.size != 1

      op = OptionParser.new do |opt|
          opt.banner = 'check_dep [options] <file>'
          opt.separator ''
      end

      params = op.parse! args

      { input_file: params.first }
    end
  end
end
