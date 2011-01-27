module SolrSearch
  class Search < ActiveRecord::Base
    cattr_accessor :form_configuration

    serialize :options, Hash
    
    class << self
      def searches(klass)
        @searches = klass
      end

      def search_class
        return @searches if @searches

        name = to_s
        name.match(/(.+)Search/)[1].constantize
      end

      def configuration
        new_configuration = FormConfiguration.new
        yield(new_configuration)
        self.form_configuration = new_configuration
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

    def keywords=(words)
      options[:keywords] = words
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

    def sort_by=(attribute)
      options[:sort_by] = attribute
    end

    def sort_direction=(direction)
      options[:sort_direction] = direction
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

    def sort_by
      options[:sort_by]
    end

    def sort_direction
      options[:sort_direction]
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

    def options
      if self[:options].nil?
        write_attribute(:options, {:conditions => []})
      else
        self[:options]
      end
    end

    def search_class
      self.class.search_class
    end

    def run
      SolrSearch::SearchBuilder.run(self)
    end
  end
end
