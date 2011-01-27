require 'spec_helper'

describe SolrSearch::FormConfiguration do
  describe "Configuring sort options" do
    it "should have an accessor for the sort options" do
      subject.should respond_to(:sort_attributes, :sort_attributes=)
    end

    describe '#sort_option' do
      it "should yield to an attribute dsl" do
        subject.sort_option do |object|
          object.class.should eql(SolrSearch::FormConfiguration::AttributeDSL)
        end
      end

      it "should configure the attribute" do
        mock_attribute = mock(SolrSearch::FormConfiguration::Attribute)
        SolrSearch::FormConfiguration::Attribute.stub(:new => mock_attribute)

        mock_attribute.should_receive(:attribute=).with(:sort_name)
        mock_attribute.should_receive(:name=).with('Name')

        subject.sort_option do |option|
          option.attribute :sort_name
          option.name 'Name'
        end
      end

      it "should add the new attribute to the list" do
        mock_attribute = mock(SolrSearch::FormConfiguration::Attribute)
        SolrSearch::FormConfiguration::Attribute.stub(:new => mock_attribute)

        subject.sort_option { nil }

        subject.sort_attributes.should include(mock_attribute)
      end
    end
  end
end
