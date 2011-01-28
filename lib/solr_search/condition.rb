module SolrSearch
  class Condition
    include ActiveModel::Validations  
    include ActiveModel::Conversion  
    extend ActiveModel::Naming  

    attr_accessor :attribute, :operator, :value
    attr_accessor :search
    
    def initialize(attributes = {}, &block)
      attributes.each_pair do |name, value|
        send("#{name}=", value)
      end
    
      yield(self) if block_given?
    end
    
    def match(attribute_name)
      self.attribute = attribute_name
    end
    
    def between(range)
      self.operator = :between
      self.value = range
    end
    alias :during :between
    
    def less_than(number)
      self.operator = :less_than
      self.value = number.to_f
    end
    
    def greater_than(number)
      self.operator = :greater_than
      self.value = number.to_f
    end
    alias :more_than :greater_than
    
    def equal(attribute_value)
      self.operator = :equal
      self.value = attribute_value
    end
    alias :is :equal
    alias :equal_to :equal
    
    def any_of(array)
      self.operator = :any_of
      self.value = array
    end
    
    def all_of(array)
      self.operator = :all_of
      self.value = array
    end
    
    def to_sunspot(context)
      case operator
      when :less_than, :greater_than, :all_of, :any_of
        context.with(attribute).send(operator, value)
      else
        context.with(attribute, value)
      end
    end

    def persisted?
      false
    end

    def form_configuration
      search.form_configuration
    end
  end
end
