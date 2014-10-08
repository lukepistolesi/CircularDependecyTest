module CircularDepApp
  class GraphFactory

    def self.from_file(file_path)
      graph = Models::Graph.new

      File.readlines(file_path).each do |line|
        graph.add_arch *line.split(',').map(&:strip)
      end

      graph
    end

  end
end