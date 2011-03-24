Given /^there (?:are|is) (?:this|these) customers?:$/ do |table|
  table.hashes.each do |attributes|
    transformed = attributes.keys.inject({}) do |hash, key|
      hash[key.underscore] = attributes[key]
      hash
    end

    Customer.make(transformed)
  end
end

