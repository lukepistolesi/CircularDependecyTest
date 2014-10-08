Then(/^the output should be (\w+)$/) do |status|
  expect(@console_output).to eql [status]
end
