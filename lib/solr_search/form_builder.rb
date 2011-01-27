module SolrSearch
  class FormBuilder < ::Formtastic::SemanticFormBuilder
    def keywords(options = {})
      options.reverse_merge!(:label => 'Search')
      input :keywords, options
    end

    def sort_by(options = {})
      attributes = @object.form_configuration.sort_attributes
      collection = attributes.each.inject({}) {|hash, attr| hash[attr.name] = attr.attribute ; hash }
      options.reverse_merge!(:label => 'Sort by', :collection => collection)
      input :sort_by, options
    end

    def sort_direction(options = {})
      defaults = {:asc_label => 'In order', :desc_label => 'Reverse Order', :as => :radio }
      options.reverse_merge!(defaults)
      options[:collection] = { defaults[:asc_label] => 'asc', defaults[:desc_label] => 'desc' }
      input :sort_direction, options
    end

    def pagination_options(options = {})
      defaults = { :as => :select, :collection => @object.form_configuration.pagination_options }
      options.reverse_merge!(defaults)
      input :per_page, options
    end
  end
end
