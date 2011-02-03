module SunspotSearch
  class Railtie < Rails::Railtie
    initializer 'sunspot_search.initialize', :after => 'formtastic.initialize' do
      ActionView::Base.send :include, SunspotSearch::SearchFormHelper
    end
  end
end
