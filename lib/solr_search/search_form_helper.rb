require 'formtastic'

module SolrSearch
  module SearchFormHelper
    # do stuff

    def search_form_for(record_or_name_or_array, *args, &proc)
      # set options that need to present to construct the
      # search form

      if record_or_name_or_array.is_a? Array
        form_configuration = record_or_name_or_array.last.form_configuration
      else
        form_configuration = record_or_name_or_array.form_configuration
      end

      conditions_hash = form_configuration.condition_attributes.inject({}) do |hash, condition|
        hash[condition.attribute] = condition
        hash
      end

      # FIXME: Localization
      # This value holds the labels for operators in the select
      operators = {
        :less_than => "Less Than",
        :more_than => "More Than",
        :at_least => "At Least",
        :at_most => "At Most",
        :is => "Is",
        :before => "Before",
        :after => "After",
        :blank => "Is Blank",
        :not_blank => "Is Not Blank",
        :between => "Between",
        :yes => 'Yes',
        :no => 'No'
      }

      # This value stores the possible operators for each type
      # of attribute. The JS plugin reads this hash and updates
      # the operator drop down accordingly
      attribute_operators = {
        :integer => [:less_than, :more_than, :at_least, :at_most, :is, :blank, :not_blank, :between],
        :currency => [:less_than, :more_than, :at_least, :at_most, :is, :blank, :not_blank, :between],
        :date => [:before, :after, :is, :blank, :not_blank, :between],
        :time => [:before, :after, :is, :blank, :not_blank, :between],
        :string => [:is, :blank, :not_blank],
        :boolean => [:is, :blank, :not_blank]
      }

      options = args.extract_options!
      options[:builder] = FormBuilder
      options[:html] = {}
      options[:html]['data-condition_information'] = conditions_hash.to_json
      options[:html]['data-operators'] = operators.to_json
      options[:html]['data-attribute_operators'] = attribute_operators.to_json

      semantic_form_for(record_or_name_or_array, *(args << options), &proc)
    end
  end
end
