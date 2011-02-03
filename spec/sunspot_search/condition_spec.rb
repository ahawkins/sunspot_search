require 'spec_helper'

describe SunspotSearch::Condition do
  subject { SunspotSearch::Condition.new }

  it { should respond_to(:choices, :choices=) }

  describe "Condition#human_name" do
    it "should return the class" do
      SunspotSearch::Condition.human_name.should eql('condition')
    end

    it "should also be the model_name" do
      SunspotSearch::Condition.human_name.should eql(
        SunspotSearch::Condition.model_name)
    end
  end

  describe "#valid?" do
    before(:each) do 
      subject.attribute = :name
      subject.operator = :equal
      subject.type = :string
      subject.value = 'solr'
    end

    it "should be valid if the attribute, operator, and type are set" do
      subject.should be_valid
    end

    it "should be invalid if the attribute is missing" do
      subject.attribute = nil
      subject.should_not be_valid
    end

    it "should be invalid if the operator is missing" do
      subject.operator = nil
      subject.should_not be_valid
    end

    it "should be invalid if the type is missing" do
      subject.type = nil
      subject.should_not be_valid
    end

    it "should require a value unless the operator is blank/not_blank" do
      subject.value = nil
      subject.should_not be_valid
      subject.operator = :blank
      subject.should be_valid
      subject.operator = :not_blank
      subject.should be_valid
    end
  end

  describe "When the condition is a currency" do
    subject { SunspotSearch::Condition.new :type => :currency, :operator => :greater_than}

    it "should create a range when the operator is between" do
      subject.operator = :between
      subject.value = "$50-$1000"
      subject.attribute_value.should eql(50.0..1000.0)
    end

    it "should remove the currency" do
      subject.value = "$1000"
      subject.attribute_value.should eql(1000.0)
    end

    it "should remove ,'s" do
      subject.value = "$1,000,000"
      subject.attribute_value.should eql(1000000.0)
    end

    it "should convert euro style to floats" do
      subject.value = " $1.000,00"
      subject.attribute_value.should eql(1000.00)
    end

    it "should not remove any decimal digits" do
      subject.value = "1.000,55"
      subject.attribute_value.should eql(1000.55)
    end

    it "should convert $1 to 1" do
      subject.value = "$1"
      subject.attribute_value.should eql(1.0)
    end
  end
end
