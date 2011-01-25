class SolrSearch::Search < ActiveRecord::Base
  serialize :options

  after_initialize :initialize_options
  
  class << self
    def searches(klass)
      @searches = klass
    end

    def search_class
      return @searches if @searches

      name = to_s
      name.match(/(.+)Search/)[1].constantize
    end
  end

  def keywords
    options[:keywords]
  end

  def fields
    options[:fields]
  end

  def conditions
    options[:conditions]
  end

  def order
    options[:order]
  end

  def per_page
    options[:per_page]
  end

  def facets
    options[:facets]
  end

  def match_mode
    options[:match_mode]
  end

  def run
    SolrSearch::SearchBuilder.run(self)
  end

  protected
  def initialize_options
    # ensure the options
    # always starts with an empty
    # hash if it hasn't been 
    # initialized to something else
    self.options ||= {}
  end
end
