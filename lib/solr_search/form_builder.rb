module SolrSearch
  class FormBuilder < ::Formtastic::SemanticFormBuilder
    def form_configuration
      @form_configuration ||= @object.form_configuration
    end

    def keywords(options = {})
      options.reverse_merge!(:label => 'Search')
      input :keywords, options
    end

    def search_fields(options = {})
      attributes = @object.form_configuration.search_attributes
      collection = attributes.each.inject({}) {|hash, attr| hash[attr.name] = attr.attribute ; hash }
      options.reverse_merge!(:collection => collection, :as => :check_boxes)
      input :fields, options
    end

    def conditions(label = 'Conditions', options = {}, &block)
      options.merge!(:for => :conditions)
      options.reverse_merge!(:class => 'inputs condition')
      inputs label, options, &block
    end

    # used for the condition nested form
    def attributes(options = {})
      possible_attributes = form_configuration.condition_attributes.inject({}) do |hash, condition|
        hash[condition.name] = condition.attribute
        hash
      end
      options.merge!(:collection => possible_attributes, :as => :select)
      input :attribute, options
    end

    # used for the condition nested form
    def operators(options = {})
      options.merge!(:collection => [], :as => :select)
      input :operator, options
    end

    # used in the condition nested form
    def remove_condition_button(label = 'Remove Condition', options = {})
      options[:button_html] = {}
      options[:button_html][:class] = "remove_condition"
      commit_button label, options
    end
    def value(options = {})
      options.merge!(:as => :string)
      input :value, options
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

    def add_condition_button(label = 'Add Condition', options = {})
      options[:button_html] = {}
      options[:button_html][:class] = "add_condition"
      commit_button label, options
    end
  end
end
