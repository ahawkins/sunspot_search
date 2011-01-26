module SolrSearch
  # This class is essential a wrapper class
  # around the methods already provided
  # in the Search class. A wrapper class is used
  # because it doesn't make sense to use 
  # assignment methods in the DSL.
  # For instance do you don't want to write
  #
  # run do
  #   c.match = salary
  # end
  #
  # It makes more sense to remove the assignments
  # and call the methods instead. 
  #
  # So when you call a method on this class
  # it sets the apporiate hash values inside
  # a Search#options hash
  class DSL
    attr_accessor :search

    def initialize(search)
      self.search = search
    end

    def keywords(*args)
      search.keywords = args
    end

    def highlight(*args)
      search.highlight = args
    end

    def match(mode)
      search.match = mode
    end

    def order_by(attribute)
      search.order_by = attribute
    end

    def per_page(amount)
      search.per_page = amount
    end

    def condition(&block)
      search_condition = Condition.new
      yield(search_condition)
      search.add_condition(search_condition)
    end
  end
end
