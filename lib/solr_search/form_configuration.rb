module SolrSearch
  # This class handles the configuration of the forms. 
  # It stores things like:
  #
  #   * search fields
  #   * order options
  #   * pagination options
  #   * condition information
  # 
  # This class also users a specific DLS for expressing
  # this information in a readabled manner.
  #
  # Example use:
  # 
  # class CustomerSearch < SolrSearch::Base
  #   configuration do |form|
  #     form.attribute do |a|
  #       a.name :name    # is the name of the field in Solr
  #       a.label 'Name'  # is what is displayed in the form
  #       a.type :string  # is used to determine what (if any) operators
  #                       # can on this field
  #     end
  #
  #     form.attribute do |a|
  #       a.name = :company
  #       # omit the label, and it will default to
  #       # the the titelized version of the name
  #       # omit the type, and it will default to :string
  #     end
  #
  #     # Continue adding more attributes until
  #     # you've listed all the different things
  #     # the user can search against for this form
  #     
  #     # Now that we have all the attributes added, 
  #     # we can move on to configure other parts 
  #     # of the form.
  #
  #     # Configuring the order options is easy.
  #     # You can easily add attributes
  #     # To the order drop down like so.
  #     form.order_options :name, :company
  #
  #
  #     # You can set pagination choices as well
  #     form.pagination_options 50, 75, 100, 200
  #   end
  # end
  class FormConfiguration
    attr_accessor :sort_attributes
    attr_accessor :pagination_options

    def sort_option
      raise RuntimeError, "This method requires a block" unless block_given?
      self.sort_attributes ||= []
      new_attribute = Attribute.new
      yield(new_attribute)
      self.sort_attributes << new_attribute
    end

    class Attribute
      attr_accessor :attribute, :name
    end
  end
end
