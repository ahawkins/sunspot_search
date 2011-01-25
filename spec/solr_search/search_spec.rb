require 'spec_helper'

describe Search do 
  describe "When there is no options" do
    subject { Search.new }

    it "should initialize itself with an empty hash" do
      subject.options.should eql({})
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

  it "should delegate conditions to options" do
    subject.options.should_receive(:[]).with(:conditions).and_return({})
    subject.conditions.should eql({})
  end

  it "should delegate order to options" do
    subject.options.should_receive(:[]).with(:order).and_return([])
    subject.order.should eql([])
  end

  it "should per_page order to options" do
    subject.options.should_receive(:[]).with(:per_page).and_return([])
    subject.per_page.should eql([])
  end

  it "should delegate facets to options" do
    subject.options.should_receive(:[]).with(:facets).and_return([])
    subject.facets.should eql([])
  end  

  it "should delegate match_mode to options" do
    subject.options.should_receive(:[]).with(:match_mode).and_return(false)
    subject.match_mode.should eql(false)
  end
end
