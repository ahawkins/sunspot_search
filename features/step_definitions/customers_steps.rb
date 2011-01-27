Then /^I should see the following customer:$/ do |expected_customers|
  # table is a Cucumber::Ast::Table
  actual_table = table(tableish('#customers tr', '.name, .company'))
  expected_customers.diff!(actual_table)
end

