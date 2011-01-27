module SolrSearch
  # this class is responsible for taking
  # an SolrSearch instance and translating the various
  # options and conditions into a Sunspot call.
  # 
  # You should never have to interact with this class 
  # directly. It is only the adapter between
  # the SolrSearch model and the Sunspot query interface
  class SearchBuilder
    def self.run(search)
      Sunspot.search search.class.search_class do
        # now translate the options
        keywords search.keywords
      end
    end
  end
end
