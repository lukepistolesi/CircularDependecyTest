When(/^I run the app$/) do
  @console_output = `#{File.expand_path './check_dep.sh'} #{@input_file.path}`.split "\n"
end
