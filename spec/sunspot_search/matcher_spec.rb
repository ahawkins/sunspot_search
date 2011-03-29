require 'spec_helper'

describe 'SunspotSearch::Matchers' do
  subject { CustomerSearch.new }

  describe "condition matcher" do
    before do
      subject.configuration do |f|
        f.condition do |c|
          c.attribute = :name
          c.name = 'Name'
          c.allow = [:blank, :not_blank]
          c.type = :string
        end
      end
    end

    it { should have_condition(:name) }
    it { should have_condition(:name).named('Name') }
    it { should have_condition(:name).as_a(:string) }
    it { should have_condition(:name).allowing(:blank, :not_blank) }

    it { should have_condition(:name).
         named('Name').
         as_a(:string).
         allowing(:blank, :not_blank)
    }

    it { should_not have_condition(:fake_name) }
    it { should_not have_condition(:name).named('Fake Name') }
    it { should_not have_condition(:name).as_a(:integer) }
    it { should_not have_condition(:name).allowing(:same) }
  end

  describe "Sort matcher" do
    before do
      subject.configuration do |f|
        f.sort_option do |s|
          s.attribute = :name
          s.name = 'Name'
        end
      end
    end

    it { should sort_by(:name) }
    it { should sort_by(:name).named('Name') }

    it { should_not sort_by(:no_name) }
    it { should_not sort_by(:name).named('Oh hai') }
  end

  describe "Search matcher" do
    it { should search_for(Customer) }
    it { should_not search_for('weee') }
  end
end
