module SolrSearch
  class Condition
    include ActiveModel::Validations  
    include ActiveModel::Conversion  
    extend ActiveModel::Naming  
    
    validates :attribute, :operator, :type, :presence => {:allow_blank => false}
    validates :value, :presence => {:allow_blank => false}, :unless => proc {|c| 
      [:blank, :is_blank].include?(c.operator.to_sym) if c.operator
    }

    attr_accessor :attribute, :operator, :value
    attr_accessor :search, :choices, :type
    
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
    
    def persisted?
      false
    end

    def form_configuration
      search.form_configuration
    end

    def attribute_value
      case type.to_sym
      when :currency
        currency_attribute_value
      end
    end

    private
    def currency_attribute_value
      case operator.to_sym
      when :between
        parts = value.split('-')
        Range.new currency_to_number(parts[0].strip), currency_to_number(parts[1].strip)
      else
        currency_to_number(value)
      end
    end

    def currency_to_number(string)
      if string =~ /[,\.]\d{2}$/
        parts = string.match /(.+)[,\.](\d{2})/
        whole = parts[1].gsub /\D/, ''
        "#{whole}.#{parts[2]}".to_f
      else
        string.gsub(/\D/,'').to_f
      end
    end
   end
end
