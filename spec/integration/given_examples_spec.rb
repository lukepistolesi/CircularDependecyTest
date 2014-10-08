require_relative '../spec_helper'
require_relative '../../circular_dep_app/application'

describe 'Examples provided as homework', :integration do

  it 'recognizes the deadlock' do
    arches = [
      { process: 'One', resource: 'A', type: 'H'},
      { process: 'One', resource: 'B', type: 'W'},
      { process: 'Two', resource: 'A', type: 'W'},
      { process: 'Two', resource: 'B', type: 'H'}
    ]
    input_file = IntegrationHelper.create_graph_file arches

    output_lines = IntegrationHelper.run_application_with input_file: input_file.path

    expect(output_lines).to eql ['BAD']
  end

end