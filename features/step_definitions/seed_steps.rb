Given /^there (?:are|is) (?:this|these) customers?:$/ do |table|
  table.hashes.each do |attributes|
    transformed = attributes.keys.inject({}) do |hash, key|
      hash[key.underscore] = attributes[key]
      hash
    end

    Customer.make(transformed)
  end

  Customer.solr_reindex :batch_commit => false, :batch_size => nil
end

