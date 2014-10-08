class CucumberHelper

  def self.write_graph(hash_arches, input_file)
    hash_arches.each do |arch|
      input_file.write "#{arch[:process]},#{arch[:resource]},#{arch[:type]}\n"
    end
  end

end