require 'spec_helper'

describe SunspotSearch::SearchBuilder do
  subject { SunspotSearch::SearchBuilder }

  before(:each) do 
    @sunspot = mock(Sunspot::Search::StandardSearch).as_null_object
    Sunspot::Search::StandardSearch.stub(:new => @sunspot)
  end

  # setup a mock search that contains the basics
  # then further mocks/stubs can be added in each specific
  # test case
  before(:each) do
    @mock_search = mock(SunspotSearch::Search, :search_class => Customer).as_null_object
  end

  it "should create a search for the associated class" do
    Sunspot.should_receive(:search).with(Customer)
    subject.run @mock_search
  end

  it "should set the keywords on the Sunspot search object" do
    pending
    @mock_search.stub(:keywords => 'this is a test')
    @sunspot.should_receive(:keywords).with('this is a test')  
    subject.run @mock_search
  end
end
