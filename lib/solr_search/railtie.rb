module SolrSearch
  class Railtie < Rails::Railtie
    initializer 'solr_search.initialize', :after => 'formtastic.initialize' do
      ActionView::Base.send :include, SolrSearch::SearchFormHelper
    end
  end
end
