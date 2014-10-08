Given(/^the following processes and resources$/) do |table|
  table.map_headers!('Process' => :process, 'Resource' => :resource, 'Interaction' => :type)
  table.map_column!('Interaction') do |type|
    case type
      when 'Holds'
        'H'
      when 'Waits'
        'W'
      else
        raise "Arch type #{type} not supproted"
    end
  end
  CucumberHelper.write_graph table.hashes, @input_file
  @input_file.close
end
