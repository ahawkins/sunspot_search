require 'formtastic'

module SolrSearch
  module SearchFormHelper
    # do stuff

    def search_form_for(record_or_name_or_array, *args, &proc)
      # set options that need to present to construct the
      # search form

      options = args.extract_options!
      options[:builder] = FormBuilder

      semantic_form_for(record_or_name_or_array, *(args << options), &proc)
    end
  end
end
