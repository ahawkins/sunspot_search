Then /^I should see the following options for "([^"]*)":$/ do |label, table|
  table.hashes.each do |value|
    steps %Q{Then I select "#{value['option']}" from "#{label}"}
  end
end
