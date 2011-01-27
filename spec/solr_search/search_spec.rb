require 'spec_helper'

describe Search do 
  describe "the class" do
    it "should have an accessor for the form configuration" do
      subject.should respond_to(:form_configuration)
      subject.should respond_to(:form_configuration=)
    end
  end

  describe "When there is no options" do
    subject { Search.new }

    it "should initialize conditions to an emtpy array" do
      subject.conditions.should eql([])
    end

    it "should not have nil options" do
      subject.options.should_not be_nil
    end

    it "should not raise an error when attributes are passed in" do
      lambda { Search.new :keywords => 'oh hai' }.should_not raise_error
    end
  end

  it "should put the keywords in the options" do
    subject.keywords = 'double legit programmers'
    subject.keywords.should eql('double legit programmers')
  end

  it "should put the hlighlight words in the options" do
    subject.highlight = 'a','b','c'
    subject.highlight.should eql(%w(a b c))
  end

  it "should put the fields words in the options" do
    subject.fields = 'a','b','c'
    subject.fields.should eql(%w(a b c))
  end

  it "should put the match in the options" do
    subject.match = :all
    subject.match.should eql(:all)
  end

  it "should put the sort in the options" do
    subject.sort_by = :name
    subject.sort_by.should eql(:name)
  end

  it "should put the per page amount in the options" do
    subject.per_page = 50
    subject.per_page.should eql(50)
  end

  describe "Setting the conditions" do
    it "should create a new condition from each hash" do
      expected = { :attribute => 'name', :operator => 'less_than', :value => 5 }
      
      mock_condition = mock(SolrSearch::Condition)

      SolrSearch::Condition.should_receive(:new).with(expected).exactly(3).times.and_return(mock_condition)
      subject.conditions.should_receive(:<<).with(mock_condition).exactly(3).times

      subject.conditions_attributes= {1 => expected, 2 => expected, 3 => expected }
    end
  end

  it "should delegate keywords to options" do
    subject.options.should_receive(:[]).with(:keywords).and_return([])
    subject.keywords.should eql([])
  end

  it "should delegate field to options" do
    subject.options.should_receive(:[]).with(:fields).and_return([])
    subject.fields.should eql([])
  end

  it "should delegate highlight to options" do
    subject.options.should_receive(:[]).with(:highlight).and_return([])
    subject.highlight.should eql([])
  end

  it "should delegate conditions to options" do
    subject.options.should_receive(:[]).with(:conditions).and_return({})
    subject.conditions.should eql({})
  end

  it "should delegate sort_by to options" do
    subject.options.should_receive(:[]).with(:sort_by).and_return([])
    subject.sort_by.should eql([])
  end

  it "should per_page order to options" do
    subject.options.should_receive(:[]).with(:per_page).and_return([])
    subject.per_page.should eql([])
  end

  it "should delegate facets to options" do
    subject.options.should_receive(:[]).with(:facets).and_return([])
    subject.facets.should eql([])
  end  

  it "should delegate match mode to options" do
    subject.options.should_receive(:[]).with(:match).and_return(:any)
    subject.match.should eql(:any)
  end
end
