module SolrSearch
  class Condition
    include ActiveModel::Validations  
    include ActiveModel::Conversion  
    extend ActiveModel::Naming  
    
    validates :attribute, :operator, :type, :presence => {:allow_blank => false}
    validates :value, :presence => {:allow_blank => false}, :unless => proc {|c| 
      c.operator && (c.operator.to_sym == :blank || c.operator.to_sym == :is_blank)
    }

    attr_accessor :attribute, :operator, :value
    attr_accessor :search, :choices, :type, :hint
    
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
      when :currency, :float
        currency_attribute_value
      when :integer
        integer_attribute_value
      when :string
        value
      when :time
        time_attribute_value
      end
    end

    private
    def integer_attribute_value
      case operator.to_sym
      when :between
        parts = value.split('-')
        Range.new currency_to_number(parts[0].strip).to_i, currency_to_number(parts[1].strip).to_i
      else
        currency_to_number(value).to_i
      end
    end
    
    def time_attribute_value
      case operator.to_sym
      when :between
        parts = value.split('-')
        Range.new Time.parse(parts[0]), Time.parse(parts[1])
      when :equal
        time = Time.parse value
        time.at_beginning_of_day..time.end_of_day
      else
        Time.parse value
      end
    end

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
      if string =~ /[,\.]\d\d?$/
        parts = string.match /(.+)[,\.](\d\d?)/
        whole = parts[1].gsub /\D/, ''
        "#{whole}.#{parts[2]}".to_f
      else
        string.gsub(/\D/,'').to_f
      end
    end
   end
end
