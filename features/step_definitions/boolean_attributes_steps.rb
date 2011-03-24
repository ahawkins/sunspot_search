Given /^"([^"]*)" has bought products$/ do |name|
  customer = Customer.find_by_name!(name)
  customer.bought_products = true
  customer.save!
end

Given /^"([^"]*)" has not bought products$/ do |name|
  customer = Customer.find_by_name! name
  customer.bought_products = false
  customer.save!
end

Given /^there is no record of "([^"]*)"'s transactions$/ do |name|
  customer = Customer.find_by_name! name
  customer.bought_products = nil
  customer.save!
end

