require 'aruba/cucumber'
require_relative 'cucumber_helper.rb'

Aruba.configure do |config|
  # config.before_cmd do |cmd|
  #   puts "About to run '#{cmd}'"
  # end
end

# Example of a Before block
# Before('@slow_process') do
#   @aruba_io_wait_seconds = 5
# end

Before do
  @input_file = Tempfile.new 'input.csv'
end

After do
  @input_file.unlink
end
