module SolrSearch
  class Search < ActiveRecord::Base
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

    def conditions_attributes=(attributes)
      attributes.each_pair do |_, condition_attributes|
        conditions << Condition.new(condition_attributes)
      end
    end

    def conditions=(array)
      options[:conditions] = array
    end

    def keywords=(args)
      options[:keywords] = *args
    end

    def highlight=(args)
      options[:highlight] = *args
    end

    def fields=(args)
      options[:fields] = *args
    end

    def match=(mode)
      raise unless [:any, :all].include? mode.to_sym
      options[:match] = mode
    end

    def order_by=(attribute)
      options[:order_by] = attribute
    end

    def per_page=(amount)
      options[:per_page] = amount
    end

    def keywords
      options[:keywords]
    end

    def fields
      options[:fields]
    end

    def highlight
      options[:highlight]
    end

    def conditions
      options[:conditions]
    end

    def order_by
      options[:order_by]
    end

    def per_page
      options[:per_page]
    end

    def facets
      options[:facets]
    end

    def match
      options[:match]
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
      self.conditions ||= []
    end
  end
end
