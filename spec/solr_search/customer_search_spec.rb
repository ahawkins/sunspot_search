require 'spec_helper'

describe CustomerSearch do
  it "should know what class to search from the class name" do
    subject.class.search_class.should eql(Customer)
  end
end
