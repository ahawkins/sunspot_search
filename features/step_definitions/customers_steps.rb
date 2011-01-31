Then /^I should see the following customers?:$/ do |expected_customers|
  # table is a Cucumber::Ast::Table
  actual_table = table(tableish('#customers tr', '.name, .company'))
  expected_customers.diff!(actual_table)
end

Then /^I should not see any customers$/ do
  actual_table = table(tableish('#customers tr', '.name, .company'))
  actual_table.hashes.size.should eql(0)
end

