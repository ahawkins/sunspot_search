module SunspotSearch
  autoload :Base, 'sunspot_search/base'
  autoload :Condition, 'sunspot_search/condition'
  autoload :DSL, 'sunspot_search/dsl'
  autoload :SearchFormHelper, 'sunspot_search/search_form_helper'
  autoload :SearchBuilder, 'sunspot_search/search_builder'
  autoload :FormBuilder, 'sunspot_search/form_builder'
  autoload :FormConfiguration, 'sunspot_search/form_configuration'
  autoload :Matchers, 'sunspot_search/matchers'
end

if defined?(::Rails)
  if Rails::VERSION::MAJOR == 3
    require 'sunspot_search/railtie'
  else
    # do it the old fashioned way
    class ActionView::Base
      include SunspotSearch::SearchFormHelper
    end
  end
end
