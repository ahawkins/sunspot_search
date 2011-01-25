require 'spec_helper'

describe CompanyCustomerSearch do
  it "should use the searches method to set the class" do
    subject.class.search_class.should eql(Customer)
  end
end
