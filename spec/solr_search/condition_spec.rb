require 'spec_helper'

describe SolrSearch::Condition do
  subject { SolrSearch::Condition.new }

  describe "#match" do
    it "should set the attribute to the argument" do
      subject.match :name
      subject.attribute.should eql(:name)
    end
  end
  
  describe "#between" do
    it "should set the operator to :between when between is called" do
      subject.between 1..5
      subject.operator.should eql(:between)
    end

    it "should set the value to the argument" do
      subject.between 1..5
      subject.value.should eql(1..5)
    end
  end

  describe "#less_than" do
    it "should set the operator to :less_than when less_than is called" do
      subject.less_than 4 
      subject.operator.should eql(:less_than)
    end

    it "should set the value to the argument" do
      subject.less_than 4
      subject.value.should eql(4.0)
    end
  end

  
  describe "#greater_than" do
    it "should set the operator to :greater_than when more_than is called" do
      subject.greater_than 4 
      subject.operator.should eql(:greater_than)
    end

    it "should set the value to the argument" do
      subject.greater_than 4
      subject.value.should eql(4.0)
    end
  end

  describe "#equal" do
    it "should set the operator to :equal when equal is called" do
      subject.equal 4 
      subject.operator.should eql(:equal)
    end

    it "should set the value to the argument" do
      subject.equal 4
      subject.value.should eql(4)
    end
  end
  
  describe "#any_of" do
    it "should set the operator to :any_of when any_of is called" do
      subject.any_of %w(a b c e d f)
      subject.operator.should eql(:any_of)
    end

    it "should set the value to the argument" do
      subject.any_of %w(1 2 3 4 )
      subject.value.should eql(%w(1 2 3 4))
    end
  end

  describe "#all_of" do
    it "should set the operator to :all_of when all_of is called" do
      subject.all_of %w(a b c e d f)
      subject.operator.should eql(:all_of)
    end

    it "should set the value to the argument" do
      subject.all_of %w(1 2 3 4 )
      subject.value.should eql(%w(1 2 3 4))
    end
  end

  describe "#to_sunspot" do
    before(:each) do
      @mock_restriction = mock(Object).as_null_object
      @mock_search = mock(Object, :with => @mock_restriction).as_null_object
    end

    describe "when the operator is :less_than" do
      subject do 
        SolrSearch::Condition.new do |c|
          c.match :name
          c.less_than 5
        end
      end

      it "should create a with(attribute).less_than restriction" do
        @mock_restriction.should_receive(:less_than).with(5)
        subject.to_sunspot(@mock_search)
      end
    end
    
    describe "when the operator is :greater_than" do
      subject do 
        SolrSearch::Condition.new do |c|
          c.match :name
          c.greater_than 5
        end
      end

      it "should create a with(attribute).greater_than restriction" do
        @mock_restriction.should_receive(:greater_than).with(5)
        subject.to_sunspot(@mock_search)
      end
    end

    describe "when the operator is :all_of" do
      subject do 
        SolrSearch::Condition.new do |c|
          c.match :name
          c.all_of 1..5
        end
      end

      it "should create a with(attribute).all_of restriction" do
        @mock_restriction.should_receive(:all_of).with(1..5)
        subject.to_sunspot(@mock_search)
      end
    end

    describe "when the operator is :any_of" do
      subject do 
        SolrSearch::Condition.new do |c|
          c.match :name
          c.any_of 1..5
        end
      end

      it "should create a with(attribute).any_of restriction" do
        @mock_restriction.should_receive(:any_of).with(1..5)
        subject.to_sunspot(@mock_search)
      end
    end
  end
end
