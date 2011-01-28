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
      sunspot_search = Sunspot.search search.search_class do
        # now translate the options
        
        if search.keywords
          keywords(search.keywords) do
            searchable_fields = search.fields.reject(&:blank?)
            fields(*searchable_fields) if !searchable_fields.empty?
          end
        end

        if search.sort_by.present? && search.sort_direction.present?
          order_by search.sort_by, search.sort_direction
        end

        if search.per_page.present?
          paginate :per_page => search.per_page, :page => (search.page.blank? ? 1 : search.page)
        end
      end

      sunspot_search
    end
  end
end
