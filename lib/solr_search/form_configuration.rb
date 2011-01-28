module SolrSearch
  class FormConfiguration
    attr_accessor :condition_attributes
    attr_accessor :search_attributes
    attr_accessor :sort_attributes
    attr_accessor :pagination_options

    def sort_option
      raise RuntimeError, "This method requires a block" unless block_given?
      self.sort_attributes ||= []
      new_attribute = Attribute.new
      yield(new_attribute)
      self.sort_attributes << new_attribute
    end

    def search_field
      raise RuntimeError, "This method requires a block" unless block_given?
      self.search_attributes ||= []
      new_attribute = Attribute.new
      yield(new_attribute)
      self.search_attributes << new_attribute
    end

    def condition
      raise RuntimeError, "This method requires a block" unless block_given?
      self.condition_attributes ||= []
      new_condition = ConditionAttribute.new
      yield(new_condition)
      self.condition_attributes << new_condition
    end

    private
    class Attribute
      attr_accessor :attribute, :name
    end

    class ConditionAttribute < Attribute
      attr_accessor :type, :choices, :extra
    end
  end
end
