Then /^I should see "([^\"]*)"$/ do |expected_output|
  nagiru.output.should eql(expected_output)
end