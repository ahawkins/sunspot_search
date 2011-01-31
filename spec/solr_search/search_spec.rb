require 'spec_helper'

describe Search do 
  describe "the class" do
    it "should have an accessor for the form configuration" do
      subject.should respond_to(:form_configuration)
      subject.should respond_to(:form_configuration=)
    end
  end

  describe "Setting the conditions" do
    it "should create a new condition from each hash" do
      pending
      expected = { :attribute => 'name', :operator => 'less_than', :value => 5 }
      
      mock_condition = mock(SolrSearch::Condition)

      SolrSearch::Condition.should_receive(:new).with(expected).exactly(3).times.and_return(mock_condition)
      subject.conditions.should_receive(:<<).with(mock_condition).exactly(3).times

      subject.conditions_attributes= {1 => expected, 2 => expected, 3 => expected }
    end

    it "should not raise an error" do
      bug_hash = {"0"=>{"attribute"=>"revenue", "operator"=>"less_than", "type"=>"currency", "value"=>"55", "choices"=>""}}
      subject.conditions_attributes = bug_hash
      subject.conditions.size.should eql(1)
    end
  end

  it "should have a page accessor" do
    subject.should respond_to(:page, :page=)
  end

  it "should serialize the fields" do
    subject.class.serialized_attributes.should have_key('fields')
  end
end
