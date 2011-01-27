require 'formtastic'

module SolrSearch
  module SearchFormHelper
    # do stuff

    def search_form_for(record_or_name_or_array, *args, &proc)
      # set options that need to present to construct the
      # search form

      options = args.extract_options!
      options[:builder] = SolrSearchFormBuilder

      semantic_form_for(record_or_name_or_array, *(args << options), &proc)
    end
    

    class SolrSearchFormBuilder < ::Formtastic::SemanticFormBuilder
      def keywords(options = {})
        options.reverse_merge!(:label => 'Search')
        input :keywords, options
      end
    end
  end
end
