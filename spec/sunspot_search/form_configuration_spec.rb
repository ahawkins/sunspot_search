require 'spec_helper'

describe SunspotSearch::FormConfiguration do
  it "should have an accessor for the search fields" do
    subject.should respond_to(:search_attributes, :search_attributes=)
  end

  describe '#search_field' do
    it "should yield an attribute" do
      subject.search_field do |object|
        object.class.should eql(SunspotSearch::FormConfiguration::Attribute)
      end
    end

    it "should configure the attribute" do
      mock_attribute = mock(SunspotSearch::FormConfiguration::Attribute)
      SunspotSearch::FormConfiguration::Attribute.stub(:new => mock_attribute)

      mock_attribute.should_receive(:attribute=).with(:sort_name)
      mock_attribute.should_receive(:name=).with('Name')

      subject.search_field do |option|
        option.attribute = :sort_name
        option.name = 'Name'
      end
    end

    it "should add the new attribute to the list" do
      mock_attribute = mock(SunspotSearch::FormConfiguration::Attribute)
      SunspotSearch::FormConfiguration::Attribute.stub(:new => mock_attribute)

      subject.search_field { nil }

      subject.search_attributes.should include(mock_attribute)
    end
  end

  it "should have an accessor for the condition options" do
    subject.should respond_to(:condition_attributes, :condition_attributes=)
  end

  describe '#sort_option' do
    it "should yield an condition" do
      subject.condition do |object|
        object.class.should eql(SunspotSearch::FormConfiguration::ConditionAttribute)
      end
    end

    it "should configure the condition" do
      mock_condition = mock(SunspotSearch::FormConfiguration::ConditionAttribute)
      SunspotSearch::FormConfiguration::ConditionAttribute.stub(:new => mock_condition)

      mock_condition.should_receive(:attribute=).with(:revenue)
      mock_condition.should_receive(:name=).with('Revenue')
      mock_condition.should_receive(:type=).with(:integer)

      subject.condition do |c|
        c.attribute = :revenue
        c.name = 'Revenue'
        c.type = :integer
      end
    end

    it "should add the new condition to the list" do
      mock_condition = mock(SunspotSearch::FormConfiguration::ConditionAttribute)
      SunspotSearch::FormConfiguration::ConditionAttribute.stub(:new => mock_condition)

      subject.condition { nil }

      subject.condition_attributes.should include(mock_condition)
    end
  end
  it "should have an accessor for the sort options" do
    subject.should respond_to(:sort_attributes, :sort_attributes=)
  end

  describe '#sort_option' do
    it "should yield an attribute" do
      subject.sort_option do |object|
        object.class.should eql(SunspotSearch::FormConfiguration::Attribute)
      end
    end

    it "should configure the attribute" do
      mock_attribute = mock(SunspotSearch::FormConfiguration::Attribute)
      SunspotSearch::FormConfiguration::Attribute.stub(:new => mock_attribute)

      mock_attribute.should_receive(:attribute=).with(:sort_name)
      mock_attribute.should_receive(:name=).with('Name')

      subject.sort_option do |option|
        option.attribute = :sort_name
        option.name = 'Name'
      end
    end

    it "should add the new attribute to the list" do
      mock_attribute = mock(SunspotSearch::FormConfiguration::Attribute)
      SunspotSearch::FormConfiguration::Attribute.stub(:new => mock_attribute)

      subject.sort_option { nil }

      subject.sort_attributes.should include(mock_attribute)
    end
  end

  it "should have an access for the pagination options" do
    subject.should respond_to(:pagination_options, :pagination_options=)
  end

  it "should store the pagination options using *args" do
    subject.pagination_options = 5,10,15,20
    subject.pagination_options.should eql([5,10,15,20])
  end
end
