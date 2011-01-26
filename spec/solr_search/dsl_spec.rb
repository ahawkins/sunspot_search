require 'spec_helper'

describe SolrSearch::DSL do
  before(:each) do 
    @mock_search = mock(SolrSearch::Search)
  end

  subject { SolrSearch::DSL.new(@mock_search) }

  it "should assign the keywords when called" do
    @mock_search.should_receive(:keywords=).with(['a','b','c','d'])
    subject.keywords 'a','b','c','d'
  end
  
  it "should assign the highlight terms when called" do
    @mock_search.should_receive(:highlight=).with(['a','b','c','d'])
    subject.highlight 'a','b','c','d'
  end

  it "should assign the match mode when called" do
    @mock_search.should_receive(:match=).with(:any)
    subject.match :any
  end

  it "should assign the per page options when called" do
    @mock_search.should_receive(:per_page=).with(50)
    subject.per_page 50
  end

  it "should assign the order when called" do
    @mock_search.should_receive(:order_by=).with(:name)
    subject.order_by :name
  end

end
