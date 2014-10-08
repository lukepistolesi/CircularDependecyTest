require_relative '../spec_helper'
require_relative '../../circular_dep_app/application'

describe 'Extra examples to match the cucumber version', :integration do

  it 'recognizes multiple deadlock' do
    arches = [
      { process: 'One', resource: 'A', type: 'H'},
      { process: 'One', resource: 'B', type: 'W'},
      { process: 'Two', resource: 'A', type: 'W'},
      { process: 'Two', resource: 'B', type: 'H'},
      { process: 'Three', resource: 'C', type: 'H'},
      { process: 'Three', resource: 'D', type: 'W'},
      { process: 'Four',  resource: 'C', type: 'W'},
      { process: 'Four',  resource: 'D', type: 'H'}
    ]
    input_file = IntegrationHelper.create_graph_file arches

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    expect(output_lines).to eql ['BAD']
  end

  it 'verything is ok when waitin for multiple resources' do
    arches = [
      { process: 'One', resource: 'A', type: 'W'},
      { process: 'One', resource: 'B', type: 'H'},
      { process: 'Two', resource: 'A', type: 'W'}
    ]
    input_file = IntegrationHelper.create_graph_file arches

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    expect(output_lines).to eql ['GOOD']
  end

end