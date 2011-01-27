module SolrSearch
  autoload :Search, 'solr_search/search'
  autoload :Condition, 'solr_search/condition'
  autoload :DSL, 'solr_search/dsl'
  autoload :SearchFormHelper, 'solr_search/search_form_helper'
  autoload :SearchBuilder, 'solr_search/search_builder'
end

if defined?(::Rails)
  if Rails::VERSION::MAJOR == 3
    require 'solr_search/railtie'
  else
    # do it the old fashioned way
    module ActiveView::Base
      include SolrSearch::SearchFormHelper
    end
  end
end
