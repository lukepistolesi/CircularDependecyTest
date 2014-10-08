require 'tempfile'

class IntegrationHelper

  def self.create_graph_file(arches)
    file = Tempfile.new 'graph.txt'
    items.each { |arch| file.write "#{arch[:process]}, #{arch[:resource]}, #{arch[:type]}\n" }
    file.close
    file
  end

  def self.run_application_with(input_hash)
    old_stdout = $stdout
    new_stdout = StringIO.new
    $stdout = new_stdout
    begin
      CircularDepApp::Application.run [input_hash[:input_file]]
    ensure
      $stdout = old_stdout
    end
    new_stdout.string.split "\n"
  end

end