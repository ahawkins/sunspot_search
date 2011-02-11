module SunspotSearch
  class FormBuilder < ::Formtastic::SemanticFormBuilder
    def form_configuration
      @form_configuration ||= @object.form_configuration
    end

    def keywords(options = {})
      options.reverse_merge!(:label => 'Search')
      options[:input_html] ||= {}
      options[:input_html][:class] ||= ''
      options[:input_html][:class] += 'keywords'
      input :keywords, options
    end

    def search_fields(options = {})
      attributes = @object.form_configuration.search_attributes
      collection = attributes.each.inject({}) {|hash, attr| hash[attr.name] = attr.attribute ; hash }
      options.reverse_merge!(:collection => collection, :as => :check_boxes)
      input :fields, options
    end

    def conditions(label = 'Conditions', options = {}, &block)
      @object.conditions ||= []
      @object.conditions << SunspotSearch::Condition.new(:search => @object)

      options.merge!(:for => :conditions)
      options.reverse_merge!(:class => 'inputs condition')
      inputs label, options, &block
    end

    # used for the condition nested form
    def attributes(options = {})
      possible_attributes = form_configuration.condition_attributes.inject(ActiveSupport::OrderedHash.new) do |hash, condition|
        hash[condition.name] = condition.attribute
        hash
      end

      possible_attributes = possible_attributes.sort { |c1, c2| c1.first.downcase <=> c2.first.downcase }

      options.merge!(:collection => possible_attributes, :as => :select)
      options[:input_html] ||= {}
      options[:input_html][:class] ||= ''
      options[:input_html][:class] = 'condition_attribute'

      if @object.attribute.present?
        options[:input_html][:class] += ' preselected'
        options[:input_html]['data-selected'] = @object.attribute
      end
      input :attribute, options
    end

    def type
      input :type, :as => :hidden, :wrapper_html => {:style => 'display:none' }, :input_html => {:class => 'type'}
    end

    def dynamic
      input :dynamic, :as => :hidden, :wrapper_html => {:style => 'display:none' }, :input_html => {:class => 'dynamic'}
    end

    # used for the condition nested form
    def operators(options = {})
      options.merge!(:as => :select)

      options[:input_html] ||= {}
      options[:input_html][:class] ||= ''
      options[:input_html][:class] += ' condition_operator'
    
      options[:wrapper_html] ||= {}

      if @object.operator.blank?
        options[:wrapper_html][:style] = 'display: none'
        options[:collection] = []
      else
        options[:input_html]['data-selected'] = @object.operator
        options[:input_html][:class] += ' preselected'
      end

      input :operator, options
    end

    # used in the condition nested form
    def remove_condition_button(label = 'Remove Condition', options = {})
      options[:button_html] ||= {}
      options[:button_html][:class] ||= ''
      options[:button_html][:class] += " remove_condition"
      commit_button label, options
    end

    def value(options = {})
      options.merge!(:as => :string)

      options[:wrapper_html] ||= {}
      options[:wrapper_html][:class] = 'value'

      if @object.value.blank?
        options[:wrapper_html][:style] = 'display: none'
        options[:hint] = 'PLACEHOLDER'
      else
        selected_attribute = form_configuration.condition_attributes.select do |c| 
          c.attribute.to_sym == @object.attribute.to_sym
        end.first
        options[:hint] = selected_attribute.hint

        options[:input_html] ||= {}
        options[:input_html]['data-selected'] = @object.value
      end

      input :value, options
    end

    def choices(options = {})
      options.merge!(:as => :select, :collection => [])

      options[:wrapper_html] ||= {}

      if @object.choices.blank?
        options[:wrapper_html][:style] = 'display: none'
      end

      options[:wrapper_html][:class] ||= ' '
      options[:wrapper_html][:class] += 'choices'

      options[:input_html] ||= {}
      options[:input_html][:class] = 'choices'
      input :choices, options
    end


    def sort_by(options = {})
      attributes = form_configuration.sort_attributes
      collection = attributes.each.inject({}) {|hash, attr| hash[attr.name] = attr.attribute ; hash }
      options.reverse_merge!(:label => 'Sort by')
      options.merge!(:collection => collection, :include_blank => false)
      input :sort_by, options
    end

    def sort_direction(options = {})
      defaults = {:asc_label => 'In order', :desc_label => 'Reverse Order', :as => :radio }
      options.reverse_merge!(defaults)
      options[:collection] = { options[:asc_label] => 'asc', options[:desc_label] => 'desc' }
      options.merge!(:include_blank => false)
      input :sort_direction, options
    end

    def pagination_options(options = {})
      defaults = { :as => :select, :collection => form_configuration.pagination_options }
      options.reverse_merge!(defaults)
      input :per_page, options
    end

    def add_condition_button(label = 'Add Condition', options = {})
      options[:button_html] ||= {}
      options[:button_html][:class] ||= ''
      options[:button_html][:class] += " add_condition"
      commit_button label, options
    end
  end
end
